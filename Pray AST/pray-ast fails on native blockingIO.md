## Context

`pray-ast` (`/Users/zishen/Documents/pray-ast`) is a single-process **cooperative
concurrency-testing scheduler**. At import time it rewrites user source via AST
transformers (`primitive_rewriter.py`, `lock_instrumentation.py`,
`heap_access_instrumentation.py`) to inject `_pray.yield_point()` calls and to redirect
`threading` / `multiprocessing` / `queue` imports to cooperative in-process
replacements. The transformed code is run by `exec(code, module.__dict__)`
(`pray_source_loader.py:402`) with a `_pray` scheduler handle injected into the module
namespace.

The scheduler (`scheduler/scheduler_base.py`) drives threads with a **single run
token**: each registered thread owns a `threading.Event`; the scheduler runs exactly
one thread at a time by `.set()`-ing its event while every other thread parks on
`event.wait()` (see `events[tid].wait()` / `ev.set()` around `scheduler_base.py:163-240`,
`block_on_object`/`wake_from_object` at `:404-439`). A thread only **hands off the
token** when it reaches an instrumented `yield_point()` or blocks on a cooperative
primitive.

**The root failure condition:** any call that blocks inside **native C code** (and
typically releases the GIL) contains **no `yield_point()`** — the transformers only
instrument Python-level AST, never the C library internals. So the running thread parks
in the kernel while *still holding the run token*. The scheduler cannot preempt it and
cannot schedule any other thread to produce the event that would wake it.

This report enumerates the **Python standard-library native blocking I/O** APIs that
trigger this, the resulting failure mode, and why pray's existing defenses don't cover
them. **Scope: stdlib native I/O only. Deliverable: written report only — no code
changes are proposed here.**

---

## Three failure modes

Every entry below resolves to one of these:

- **A. Hard deadlock** — the call unblocks only when *another in-process thread* acts
  (e.g. writes the pipe, connects the socket, releases the lock). That thread can never
  run because the blocked thread holds the token. The whole program hangs permanently.
- **B. Silent unsoundness / serialization** — the call unblocks via an *external* event
  (a wall-clock timer, an outside network peer). No crash, but during the block the
  scheduler is frozen, real time passes, and the systematic interleaving exploration
  pray exists to provide is defeated. Results look fine but are **invalid**.
- **C. Indefinite hang** — the call waits on input that never arrives in an automated
  run (stdin, a signal). Hangs until killed.

A key contrast: `multiprocessing.Process/Pool/Manager` **fail loudly** today
(`NotImplementedError`, `pray_source_loader.py:161-174`). Everything in this report
**fails silently** — there is no detection, no warning, just a hang or bad data.

---

## The libraries

### 1. `time.sleep()` — modes B / A
Releases the GIL and blocks the OS thread in C. Extremely common as a crude "wait for
the other thread" device. Holding the token freezes all other threads for the sleep
duration (B); if a thread sleeps *expecting* another thread to make progress meanwhile,
that progress never happens → deadlock-equivalent (A). Not instrumented, no yield point.

### 2. `socket` — mode A
`socket.recv()`, `.send()` (on a full buffer), `.accept()`, `.connect()`,
`.recvfrom()` all block in the kernel with the GIL released. The classic in-process
loopback client/server pattern deadlocks immediately: the server thread blocks on
`accept()`/`recv()` holding the token, so the client thread can never run to
`connect()`/`send()`. `socket` is **not** in the replacement registry and — notably —
**not even in `DEFAULT_EXCLUDE_PREFIXES`** (`commands/_utils.py:46-104`), despite the
comment there explicitly naming "socket I/O the cooperative scheduler cannot model".

### 3. `select` / `selectors` — mode A
`select.select()`, `.poll()`, `.epoll()`, `.kqueue()`, and
`selectors.DefaultSelector().select()` block waiting for fd readiness. When readiness
depends on another in-process thread, same token-holding deadlock.

### 4. `os` low-level pipe / fd I/O — mode A
`os.read()` / `os.write()` on `os.pipe()` fds, and reads on `os.mkfifo()` FIFOs, block
in C. A blocking `os.read()` on an empty pipe holds the token; the writer thread can
never run → deadlock. (These are the same native primitives that force `multiprocessing`
and `queue` onto the cooperative replacements; raw `os`-level use is unguarded.)

### 5. `subprocess` — modes A / C
`subprocess.run()`, `Popen.wait()`, `Popen.communicate()`, and `os.waitpid()` block
waiting on a child process. The cooperative scheduler models a *single* process and
cannot schedule the child, so the parent thread blocks holding the token. Reads from the
child's stdout/stderr pipes block the same way. Unlike `multiprocessing.Process`,
`subprocess` is **not rejected** — it blocks silently.

### 6. `signal` — mode C
`signal.pause()`, `signal.sigwait()` block until a signal arrives, holding the token.
Signal delivery is also unreliable under cooperative scheduling (signals target the main
thread / interrupt the kernel wait unpredictably). In an automated run with no signal
source, hangs forever.

### 7. `sys.stdin` / `input()` — mode C
`input()`, `sys.stdin.read()`/`.readline()` block in C waiting for terminal or pipe
input. A systematic-testing run is non-interactive, so these hang indefinitely while
holding the token.

### 8. `ssl` — mode A
`ssl.SSLSocket.do_handshake()`, `.recv()`, `.send()` wrap a real socket and perform
blocking native I/O — identical deadlock profile to plain `socket` (#2), plus the
handshake round-trips.

### 9. `_thread` (low-level) — mode A
`_thread.allocate_lock()` returns a **real native lock** whose `.acquire()` blocks in C,
and `_thread.start_new_thread()` spawns an uninstrumented thread. The `PrimitiveRewriter`
redirects only `threading` / `multiprocessing` / `queue`
(`primitive_rewriter.py:11-15`) — **never `_thread`**. So code (or a dependency) using
`_thread` directly gets uncooperative locks the scheduler cannot observe: if one thread
holds such a lock and yields, another thread blocking on it parks in native C holding the
token → deadlock. This is the most insidious entry because it can arrive transitively
through library code.

### 10. `fcntl` advisory file locks — mode A/B
`fcntl.flock()` / `fcntl.lockf()` block in the kernel until a lock is available. If
contention is between two in-process threads, the blocked one holds the token → deadlock.

---

## Why pray's existing defenses don't cover these

- **`DEFAULT_EXCLUDE_PREFIXES` only prevents *instrumentation* crashes, not blocking.**
  Excluding `asyncio`/`urllib`/`http`/`httpx` etc. (`_utils.py:68-104`) stops pray from
  AST-rewriting those modules (which would deadlock on import-time locks). It does
  **nothing** to make a blocking call inside them safe — the native block still freezes
  the token. And the lowest-level offenders (`socket`, `select`, `os`, `subprocess`,
  `signal`, `_thread`, `time`) are not in the list at all.
- **No detection / no warning.** Cross-process `multiprocessing` constructs raise
  `NotImplementedError` (`pray_source_loader.py:161-174`), giving a clear signal. None of
  the native I/O paths above have any equivalent guard, so they manifest as a silent hang
  (A/C) or — worse — as **passing-but-invalid** test runs (B).

---

## Summary table

| Library / call | Mode | Guarded today? |
|---|---|---|
| `time.sleep()` | B / A | No |
| `socket` recv/send/accept/connect | A | No (not even excluded) |
| `select` / `selectors` | A | No |
| `os.read`/`os.write` on pipe/FIFO | A | No |
| `subprocess` run/wait/communicate, `os.waitpid` | A / C | No |
| `signal.pause` / `sigwait` | C | No |
| `input()` / `sys.stdin` reads | C | No |
| `ssl` handshake/recv/send | A | No |
| `_thread.allocate_lock` / `start_new_thread` | A | No (rewriter skips `_thread`) |
| `fcntl.flock` / `lockf` | A / B | No |

## Bottom line

pray-ast is sound only for programs whose blocking happens through the cooperative
primitives it intercepts (`threading`, `queue`, single-process `multiprocessing`
locks/queues/pipes). **Any stdlib native blocking I/O** — anything that descends into C
and waits on the kernel — has no yield point, so the blocked thread keeps the single run
token and either deadlocks the scheduler (A), invalidates the interleaving exploration
silently (B), or hangs indefinitely (C). The `socket` / `_thread` / `time.sleep` cases
are the highest-risk because they are common, can arrive transitively through libraries,
and (except where noted) are not even flagged by the existing exclusion list.

## Verification (how to confirm any single claim)

A minimal in-process reproduction confirms mode A without modifying pray: e.g. a two-
thread program where thread 1 does `c.recv()` on a loopback socket (or `os.read()` on a
pipe) before thread 2 sends/writes, run under `pray run` with any scheduler, will hang —
contrast with the same logic over a `queue.Queue` (redirected to `CoopQueue`), which
completes. (Demo scripts were explicitly out of scope for this deliverable.)
