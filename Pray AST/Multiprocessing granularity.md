1. Every bytecode / instruction. The theoretical ceiling — maximal interleaving, but an IPC round-trip per operation. Not practical; only worth naming as the upper bound.

2. Every yield point (thread-step). Return the token at every AST-inserted yield point (what pray already emits for heap/lock/general instrumentation). Fullest joint (local×global) exploration, heaviest IPC. (the "one thread-step per token" option)

3. Every shared-data access only. Checkpoint on reads/writes of genuinely cross-process-shared state (Value/Array/Manager proxies), but skip local heap accesses. This is the key refinement over #2: because isolated memory makes local accesses invisible to other processes, you don't need global checkpoints there. Catches lock-free races (the value.value += 1 read-then-write) while cutting IPC massively.

4. Every multiprocessing operation = shared-data accesses + synchronization ops + lifecycle (start/join). (the option you proposed) Superset of #3 and #5.

5. Synchronization / communication ops only. Checkpoint only at the happens-before points — Lock.acquire/release, Event, Queue.put/get, Barrier, join — and treat raw shared reads/writes as non-checkpointing. This is the classic "preempt only at sync points" model from stateless model checkers. Much cheaper, but misses lock-free data races entirely (a program with no locks around shared memory looks race-free).

6. Only at blocking ops + exit (run-until-block). Coarsest useful level — a process runs flat-out until it would actually block or terminates. Cross-process interleaving happens only at block boundaries. Cheapest; misses the most.

So #3, #4, #5 are the interesting middle: they differ only in whether you checkpoint at (a) shared data accesses, (b) sync ops, or (c) both. #4 (both) is the sound default; #5 drops data races; #3 drops sync-only orderings.

Two orthogonal strategies (not a fixed event class)

These control the token differently — worth having in the mix:

7. Count-based quantum. Pick any event class above, then only actually return the token every N such events (N=1 is thread-step, N=∞ is run-until-block). A single knob trading IPC for interleaving resolution. Must count events, never wall-clock time — a time-slice quantum would destroy deterministic replay.

8. Preemption-bounded (PCT-style). Don't fix where checkpoints happen — instead run freely but let the coordinator inject at most c context switches, placed at chosen points, bounding the schedule space by number of preemptions rather than granularity. This isn't hypothetical: pray's existing PCT scheduler already does exactly this at the thread level, so it could be lifted to the process level almost directly — arguably the most natural fit given the codebase.
