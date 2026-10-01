---
tags: [ai-drafted]
---
**Global Interpreter Lock**: a mutex in CPython that lets only **one OS thread execute Python bytecode at a time** per interpreter.

# Why it exists
- CPython memory management is [[Python Memory Model | reference counting]] (`ob_refcnt`). Without a lock, concurrent `Py_INCREF`/`Py_DECREF` would race, causing leaks or use-after-free.
- One big lock is simpler and faster single-threaded than fine-grained locks on every object, and it made C extensions easy to write safely.

# How switching works
- A thread holding the GIL is asked to drop it after a **switch interval** (`sys.getswitchinterval()`, default 5 ms). It releases the GIL at the next bytecode boundary when another thread is waiting.
- **Blocking I/O and many C extensions release the GIL** (`Py_BEGIN_ALLOW_THREADS`): socket/file I/O, `time.sleep`, NumPy kernels, hashlib on large buffers.
- So: **I/O-bound threads overlap fine; CPU-bound pure-Python threads do not speed up** (often slower due to contention).

# What the GIL does *not* give you
- It does **not** make your code thread-safe. `x += 1` is several bytecodes (`LOAD`, `BINARY_OP`, `STORE`), so a switch can land between the read and the write → lost update. You still need `threading.Lock` ([[Threading - events]]).
- This read/modify/write window is exactly what Pray instruments with yield points ([[heap access]]).

# Workarounds for CPU-bound work
| Option | Mechanism | Cost |
| --- | --- | --- |
| `multiprocessing` / `ProcessPoolExecutor` | separate processes, one GIL each | pickling + IPC, no shared heap ([[Python Multiprocessing vs Multithreading]]) |
| C extensions / NumPy / Cython `nogil` | release the GIL inside native code | write native code |
| Sub-interpreters (3.12+, per-interpreter GIL, PEP 684) | multiple interpreters in one process | limited object sharing |
| **Free-threaded build** (3.13+, PEP 703, `python3.13t`) | no GIL; biased refcounting + per-object locks | ~10–40% single-thread slowdown (shrinking), C-extension compatibility |

# Related
- [[AsyncIO]] (single-threaded concurrency, which sidesteps the GIL question for I/O)
- [[Python Execution Model]] · [[Thread]] · [[Pray AST]]
