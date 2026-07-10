# Multiprocessing 
Identify risk 
Evaluate threading or processing (drop down to C)
interprocess mutex 

## Fork 
The OS makes an exact copy of the parent process
The child process inherits all parents state including file descriptor, network descriptor and threads 
Dangerous because the copying 

**1. Why thread simulation breaks memory semantics**

Pray currently simulates processes with threads, but threads all live inside _one_ process and therefore share a single address space. Real processes have isolated heaps — nothing is shared unless explicitly requested. So under simulation, "processes" can silently read/write each other's globals and objects, sharing that would be impossible in a real run. This violates the isolation semantics of multiprocessing: the tool can produce interleavings/bugs that can't happen with real processes (false positives from cross-"process" memory access) and miss bugs that only arise from true isolation (e.g. pickling copies, lost updates through real IPC). This is the root of the long tail of thread-vs-process differences.

**2. Two implementations for real-process support**

_Option B — shared-memory scheduler + inter-process mutex (C):_ Spawn real processes; scheduler state lives in a shared memory region all processes map; coordination via an inter-process mutex (e.g. file lock / named semaphore) plus a signalling mechanism to wake the next process. Problem: shared memory can't hold ordinary Python objects (they implicitly malloc into private memory) and can't grow dynamically, so the scheduler needs a fixed-size layout and custom allocation — in practice a C (or Rust/Zig) library that Pray calls into. Correct by construction, but highest engineering effort.

_Option C — coordinator process (pure Python, recommended):_ Spawn real processes, but centralize the scheduler in one dedicated arbiter process instead of shared memory. Each worker, at every scheduling point, sends "may I proceed?" over a Pipe and blocks on `recv()`; the coordinator holds all scheduler state as normal Python objects in its own heap, models blocked workers (e.g. `get` on an empty queue), and replies "go" to exactly one worker at a time. Same cooperative token-passing invariant, enforced by an IPC round-trip instead of an in-memory condition variable. No shared memory, no C; cost is one IPC round-trip per scheduling point (acceptable — performance isn't the current concern).

**3. IPC and memory sharing in Python**

Processes exchange data only through explicit OS channels:

- **Pipe/Connection** — OS pipe/socket pair; `send()` pickles the object to bytes, `recv()` unpickles a _copy_. No references cross the boundary.
- **Queue** — built on a Pipe + lock + semaphore + a hidden feeder thread per producer; `put()` can return before data actually leaves the process.
- **Manager proxies** — the real object lives in a server process; every proxy method call is a pickled request over a socket (shared-_looking_, but actually message passing).
- **Sync primitives** (Lock, Semaphore, Event…) — backed by named OS semaphores so they work across address spaces.

True memory sharing is opt-in, and all of it ultimately rests on **`mmap`**: the kernel maps the _same physical pages_ into multiple processes' address spaces, so a write in one is instantly visible in the others — no copy, no pickle.

- **`mmap` module directly** — map a file (or anonymous region) shared between processes; you get a raw byte buffer and do your own layout/locking.
- **`Value` / `Array`** — fixed C types (`ctypes`) allocated in an anonymous mmap region, with an optional built-in lock; compound updates like `v.value += 1` still race without it.
- **`multiprocessing.shared_memory.SharedMemory`** — named mmap-backed block (commonly wrapped by numpy); no built-in locking, must be explicitly unlinked.