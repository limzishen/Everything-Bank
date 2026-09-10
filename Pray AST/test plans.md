# Integration test plan

## Purpose

The `tests/unit/` suite is deliberately fork-free and socket-free (see `tests/README.md`):
it exercises the coordinator's *bookkeeping* through a `StubChannel`, the ready collections,
the pure `_build_local_scheduler` factory, and the protocol dataclasses. It never installs
the import hook, never opens a `Listener`, and never forks a worker.

Everything that only happens *end to end* is therefore untested:

- the AST → import-hook → cooperative-runtime pipeline running for real;
- `Coordinator.run()` / `accept_worker()` / `reap()` against a live `Listener` and real pids;
- `run_worker` / `CoordinatorClient` / `rebind_instrumentation` after a genuine `fork()`;
- the worker-proxy ↔ coordinator-hosted primitive round trip;
- teardown, cancellation, and leak behaviour across `--runs N`.

This tier fills that gap. It is **slow, forks real processes, and opens sockets**, so it is
isolated from the default `uv run pytest tests/` invocation (see "Harness" below).

## Scope boundaries

In scope: observable behaviour of `pray run` / `pray pytest` on small targets, asserted via
exit code + stdout markers, and (where cheap) via direct `Coordinator` + `run_worker` calls.

Out of scope: AST shape assertions (unit-tested via transformer output), scheduler policy
statistics / distribution quality (belongs in `benchmark/` + `scripts/`), performance.

## Oracle convention

`pray run` can exit `0` even when the target fails a bare `assert` (see the memory note
"pray run exit code"). **Every** buggy-target assertion in this tier must check *both*:

1. process exit code, and
2. a stdout/stderr marker string printed by the target or the driver
   (`LOST-UPDATE`, `BAD`, `completed without deadlock`, `Deadlock:`, `run(s) failed`, ...).

Correct-target tests assert exit `0` **and** the success marker, and that the run finished
inside the harness wall-clock timeout (a hang is a failure, not a skip).

---

## A. Import / AST pipeline (real import hook, no processes)

Small targets imported through `setup_instrumented_module`; assert on runtime behaviour,
not AST.

| #   | Case                                                      | Assertion                                                                                                                    |
| --- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| A1  | `import threading`                                        | `threading.Lock` in the target is a `CoopLock` subclass bound to the run's scheduler                                         |
| A2  | `import threading as t` alias                             | `t.Thread` resolves to the cooperative `Thread`; run completes                                                               |
| A3  | `from threading import Lock, Event`                       | both names bind cooperative classes (direct-class-import path, not module attr)                                              |
| A4  | `import multiprocessing as mp`                            | `mp.Process is CoopProcess`; `mp.Queue`/`mp.Value`/`mp.Lock` are the synthetic factories                                     |
| A5  | `from multiprocessing import Process, Queue, Value, Lock` | all four synthetic names bound                                                                                               |
| A6  | target never imports `multiprocessing`                    | `_pray_multiprocessing_module` stays the lazy shim; the heavy mp stack (and `socket`) is not imported                        |
| A7  | `DEFAULT_EXCLUDE_PREFIXES` hit                            | an excluded dependency module gets **no** `_pray` global and is left byte-identical; a non-excluded user module gets `_pray` |
| A8  | multi-module target (`import helper_mod`)                 | instrumentation crosses the import; `helper_mod._pray` is present and bound to the same scheduler                            |
| A9  | entrypoint bootstrap                                      | `main()` wrapped with `register_thread`/`thread_done`; run with 2 threads completes and cleans up                            |
| A10 | entrypoint bootstrap quirk (**xfail / documented**)       | a *nested* or unrelated `def main` inside the target also gets wrapped — `visit_FunctionDef` matches by name anywhere        |
| A11 | `--heap-instrument` on `x[i] += 1` / `obj.attr += 1`      | RMW is decomposed; a policy finds the lost update within N runs                                                              |
| A12 | `--lock-instrument` on a fall-through `RLock`             | `.acquire()`/`.release()` gain yield points; run still completes                                                             |
| A13 | `--dry-run`                                               | instrumented source printed, target body not executed (no side-effect marker)                                                |
| A14 | `--raw`                                                   | no instrumentation installed; target runs unmodified                                                                         |

---

## B. Threading cooperative runtime (single process)

| #   | Case                                 | Assertion                                                                                                                                                                            |
| --- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| B1  | each primitive × each policy         | Lock, Event, Barrier, Condition, Semaphore, BoundedSemaphore, Thread × {rand, pos, pct, urw, surw}: a correct program stays correct over `--runs 5`                                  |
| B2  | `class W(threading.Thread)` subclass | user subclass of the rewritten `Thread` runs (the `_bind_scheduler` "real subclass, not `partial`" property)                                                                         |
| B3  | lock-ordering deadlock               | `Deadlock` raised, non-zero exit, `Deadlock:` on stderr                                                                                                                              |
| B4  | one thread raises                    | `_cancel_all_background_threads` fires; background threads unwind via `ThreadCancelled`; the *original* exception re-raised on main; non-zero exit; zero non-main threads left       |
| B5  | `--runs 20`                          | `cleanup()` leaves no leaked threads; scheduler state reset; observed interleavings vary across runs                                                                                 |
| B6  | seeded replay                        | same `--seed` ⇒ identical stdout and identical pass/fail, byte for byte                                                                                                              |
| B7  | `pray pytest` path                   | `PrayPytestPlugin` installs instrumentation at `pytest_sessionstart`, monkeypatches `threading.Thread`, `register()`/`cleanup()` per test; a buggy test fails, a correct one passes  |
| B8  | urw/surw thread-level profiling      | one-shot profiling `pray run` pass produces per-thread weights; `--thread-counts NAME=INT` overrides; under `pray pytest` the pass is disabled ⇒ uniform fallback, run still correct |

---

## C. Multiprocessing: lifecycle (real `fork()` + `Listener`)

Driven either through `pray run --mp` on a `benchmark/multiprocessing/*` target, or
directly: build a `Coordinator`, `_fork_root_worker`, `accept_worker`, `coord.run()`.

| # | Case | Assertion |
|---|------|-----------|
| C1 | root worker happy path (`proc_only_mp.py`) | hello/ack → initial token → run → `EXITED`; driver exits 0; `all children joined` printed |
| C2 | on-demand child accept | `p.start()` emits `Spawned(cid)`; coordinator calls `accept_worker()`; child connects and is scheduled |
| C3 | `join` parks then wakes | `p.join()` emits `Join(cid)`; parent parked in `_blocked`; woken exactly when the child hits `EXITED` |
| C4 | join on already-exited child | no block (cid maps to an `_exited` gpid or is unknown) → parent stays runnable |
| C5 | grandchildren | a child that itself spawns: coordinator accepts a worker the driver never forked; labels are `root/<i>/<j>`; `reap()` can still reach it via the pid recorded at hello |
| C6 | global-token invariant | across an ordered observation/log trace, exactly one worker holds the token at any moment |
| C7 | policy coverage at process granularity | rand/pos/urw/surw and pct(`--depth`/`--num-scheduling-points`): correct mp targets stay correct, children scheduled in varying orders across runs |
| C8 | determinism under `--mp --seed` | identical schedule + identical pass/fail at *both* process and thread level |
| C9 | fork context forced | run succeeds regardless of platform default start method (macOS `spawn`, 3.14 `forkserver`) |

---

## D. Multiprocessing: shared primitives (proxy ↔ hosted round trip)

| # | Case | Assertion |
|---|------|-----------|
| D1 | `ProcLock` mutual exclusion | two children, critical section guarded by a shared `Lock`: no interleaving violates exclusion; FIFO waiter wake order |
| D2 | `ProcLock` non-blocking | `acquire(blocking=False)` on a held lock returns `False` without parking |
| D3 | `ProcValue` RMW race (`counter_mp_bad.py`) | `get`/`set` decomposition makes lost updates reachable; `got < P*n` and `LOST-UPDATE` printed under a good policy |
| D4 | `ProcValue.get_lock()` / `with v:` | routes to the embedded `HostedLock`; guarded increment is race-free |
| D5 | `ProcQueue` block/wake (`queue_mp.py`) | `get` on empty parks the caller; `put` wakes exactly one getter, FIFO; final sum always `n(n+1)/2`, `OK` printed |
| D6 | `empty` / `qsize` | reflect hosted deque state |
| D7 | `obj_id` stable across fork | primitive created in the parent, used in a child, resolves to the *same* hosted object (sharing works; ordinary globals stay private) |
| D8 | `_creation_site()` stability | returns a run-stable `basename:lineno` (walks out of pray's own frames); identical between a profiling run and the real run — SURW correctness depends on this |
| D9 | op on unknown primitive | coordinator raises `RuntimeError("op on unknown primitive ...")` (should not be reachable from valid targets; guards a protocol regression) |

---

## E. Multiprocessing: abnormal outcomes (each ⇒ raise + report + non-zero exit)

| # | Case | Trigger | Assertion |
|---|------|---------|-----------|
| E1 | `WorkerFailure` | a child raises in user code | remote traceback surfaced on stderr (`--- traceback from worker N ---`); every other worker cancelled; exit 1; `run(s) failed` summary |
| E2 | `WorkerLost` | a child calls `os._exit()` / is `SIGKILL`ed mid-step | pipe EOF → `WorkerLost(gpid)`; `Worker lost:` on stderr; exit 1 |
| E3 | `StepTimeout` (holder) | a child does a real blocking OS wait (e.g. `time.sleep`, blocking `socket.recv`) with `--step-timeout 2` | `StepTimeout` raised after the deadline; `Timeout:` on stderr; exit 1 |
| E4 | `StepTimeout` (accept) | a child dies during bootstrap before `ProcHello` | `_wait_for_connection` bounds the wait; `accept_worker` raises `StepTimeout(-1, ...)` instead of wedging in `Listener.accept()` |
| E5 | cross-process `Deadlock` (`deadlock_mp_bad.py`) | two `ProcLock`s, opposite acquire order | coordinator sees no runnable worker with blocked workers remaining → `Deadlock`; exit 1; a *passing* run is the regression |
| E6 | in-worker thread `Deadlock` (`deadlock_threads_mp.py`) | two threads in one child, lock ordering | the child's local scheduler raises `Deadlock` on its main thread → reported home as `WorkerFailure`; exit 1 |
| E7 | failing run does not mask siblings | 5 runs, run #3 fails | runs #4–5 still execute; final summary `1/5 run(s) failed: #3 (...)`; exit 1 |

---

## F. Multiprocessing: teardown & leak hygiene

This is where regressions are most likely and least visible.

| # | Case | Assertion |
|---|------|-----------|
| F1 | `Shutdown` mid-critical-section | worker parked in `with lock:` receives `Shutdown` → raises `WorkerShutdown`, unwinds through `__exit__`/`finally` **without** `BrokenPipeError` (the `_shutdown` fast-fail seam), then `_hard_exit()` — no `atexit` / mp `_exit_function` hang |
| F2 | `reap()` kills survivors | a worker that ignores `Shutdown`: `reap()` `SIGKILL`s it after the grace period and returns its pid in the killed list |
| F3 | `reap()` reaches grandchildren | a killed run with a live grandchild: `reap()` signals it via the recorded pid even though the driver never forked it; no zombies (orphan reparented to init) |
| F4 | `--runs 10 --mp` back to back | zero leaked processes after the last run; no stale `AF_UNIX` socket path; fresh `authkey` per `Coordinator` |
| F5 | idempotent `close()` | `close()` on the abort path then again in `finally` does not raise |
| F6 | profiling-pass teardown | `_profile()` closes its coordinator, joins/terminates the root, and `reap()`s before the real runs start; counts survive an early `CoordinatorError` |

---

## G. Cross-layer: threads *inside* workers

| # | Case | Assertion |
|---|------|-----------|
| G1 | `rebind_instrumentation` redirects `_pray` | after fork, every module in `sys.modules` with a `_pray` global is re-pointed to the child's fresh scheduler; `ACTIVE_SCHEDULER.scheduler` and `ACTIVE.{client,config,label}` set |
| G2 | child-created lock parks on child scheduler | a `threading.Lock` created inside a worker parks that worker's threads on the worker's own (deadlock-detecting) scheduler, not the parent's |
| G3 | **residual bug (xfail)** | a threading primitive *instance* constructed *before* the fork keeps the scheduler it captured; only primitives built inside the worker are correctly rebound |
| G4 | shared `Value` + local threads | threads in two different workers increment one `multiprocessing.Value`; guarding with a *process-local* `threading.Lock` (instead of `v.get_lock()`) still races — exercises decomposition + the "process-private lock" trap |
| G5 | worker profile reported home | with urw/surw, each worker counts events while running for real and reports a `ThreadProfile` at exit, keyed by stable label |

---

## H. `--mp` profiling for urw / surw

| # | Case | Assertion |
|---|------|-----------|
| H1 | process-level counts | `_profile()` runs once under `rand`; `event_counts` keyed by label; echoed as `process-level profile: {...}` |
| H2 | label stability across runs | labels line up profiling-run → real-run even though gpids are handed out in a different schedule-dependent order |
| H3 | SURW Δ chosen once globally | `_select_interesting` picks one object over all workers' accesses; tie broken by `(count, name)` deterministically; echoed |
| H4 | single-threaded workers | "no thread-level weights were profiled ... naive random walk" note printed; runs still correct |
| H5 | `--thread-counts` / `--interesting-var` overrides | honoured; profiling still runs for the process-level weights but thread weights come from the flag |

---

## I. Known-gotcha regression tests (from prior debugging)

| # | Case | Assertion |
|---|------|-----------|
| I1 | authkey agreement | `Listener` and `Client` authkeys match ⇒ run completes; a deliberately mismatched authkey is detected fast, not hung forever in `answer_challenge` |
| I2 | no faulthandler-in-fork-child hang | a plain `pray run --mp proc_only_mp.py` finishes well inside the harness timeout |
| I3 | blocking socket under pray | a target doing a blocking `socket.recv` surfaces as `StepTimeout` with `--step-timeout`, not an unbounded hang (or the module is in `DEFAULT_EXCLUDE_PREFIXES` and documented) |
| I4 | exit-code oracle | a `_bad` target that only `assert`s (no print) — confirm this tier's stdout-marker convention actually catches it where a bare exit-code check would not |

---

## J. The "hard-to-find bug" fixture (original goal of this file)

`test_plan.md` started life as "come up with a somewhat hard-to-find bug" to use as an
oracle. Candidates that stress *composition* of the two layers rather than a single
primitive:

1. **RMW straddling the process/thread boundary (G4).** A shared `multiprocessing.Value`
   incremented by threads inside two *different* worker processes, guarded by a
   `threading.Lock`. Looks correct; the lock is process-private, so the coordinator can
   interleave the two processes between a `get` and its `set`. Fails only under a specific
   *process-level* interleaving that also requires a specific *thread-level* one inside
   each worker — needs both schedulers cooperating to reproduce.

2. **Queue/join wake-order inversion.** Producer `put`s then exits; consumer `join`s the
   producer *before* draining the queue. Reachable only when `Join`-wake ordering and
   `ProcQueue`-wake ordering interleave in exactly one way. Confirms the two wake paths in
   `_handle_yield` / `_handle_prim_op` compose correctly.

3. **Label/cid drift on nested spawn.** Children spawned in a loop where the per-process
   `_cid_counter` and the `_pray_label` index must stay aligned across runs for SURW
   replay. A drift bug shows up as non-deterministic pass/fail *under a fixed seed* — the
   worst kind to debug, and a good regression target for the label-keyed weight machinery.

Pick #1 as the primary fixture: it is the smallest program that cannot be diagnosed by
looking at either layer alone.

---

## Harness

- Directory: `tests/intergration/` (note: existing spelling). Own `conftest.py`.
- Marker: `@pytest.mark.integration`, registered in `pyproject.toml`; **excluded** from the
  default `uv run pytest tests/` via `addopts = "-m 'not integration'"` or a separate path.
- Per-test wall-clock timeout (`pytest-timeout`, or a `SIGALRM` fixture): a wedged
  coordinator must fail the test, never hang CI.
- Autouse cleanup fixture: after each test, reap stray child pids and unlink any leftover
  `AF_UNIX` socket path, even on failure. Reuse `conftest.py`'s `reset_active_worker` /
  `reset_active_scheduler` pattern.
- Run as its own CI job/step, matrixed over Python 3.10–3.13, alongside the existing
  `pray run benchmark/...` steps in `.github/workflows/ci.yml`.
- Fixtures under `tests/intergration/targets/` — tiny, single-purpose `.py` programs, or
  reuse `benchmark/multiprocessing/*` where one already fits.

## Suggested build order

1. Harness + `A` (import pipeline) — no forks, fast feedback, unblocks everything else.
2. `C1`–`C4` + `F4` (mp lifecycle + no-leak) — the load-bearing path.
3. `D` (shared primitives) against the existing `counter_mp_bad` / `queue_mp` targets.
4. `E` (abnormal outcomes) — one target per failure mode.
5. `B` (threading runtime) — largely lifts existing `benchmark/threads/*` under the marker.
6. `G` + `J` (cross-layer + the hard bug), then `H`, `I`.
