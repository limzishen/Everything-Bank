---
tags: [ai-drafted]
---
Atomic read-modify-write instruction and the building block of lock-free code.

```
// executed atomically by hardware
bool CAS(addr, expected, desired):
    if *addr == expected:
        *addr = desired
        return true
    return false
```
- x86: `LOCK CMPXCHG` (also `CMPXCHG16B` for double-width). ARM: LL/SC (`LDXR`/`STXR`), or `CAS` on ARMv8.1+.
- C++: `std::atomic<T>::compare_exchange_weak/strong`. Rust: `AtomicUsize::compare_exchange`.
  - `weak` may fail spuriously (LL/SC), so use it inside a loop. Use `strong` when not looping.

# The CAS loop pattern
```cpp
std::atomic<int> counter{0};
int old = counter.load(std::memory_order_relaxed);
while (!counter.compare_exchange_weak(old, old + 1,
                                      std::memory_order_acq_rel,
                                      std::memory_order_relaxed)) {
    // on failure `old` is reloaded with the current value, so just retry
}
```
A failed CAS means another thread made progress. That makes this **lock-free** (system-wide progress) but not **wait-free** (one thread can starve).

# Uses
- Spinlock: `while (!flag.compare_exchange_weak(false_, true)) {}` (see [[Locks]])
- Lock-free stack (Treiber stack) and queue (Michael–Scott)
- Atomic pointer flip in [[Left Right Crate]]
- [[Optimistic locking vs Pessimistic locking | Optimistic locking]] in DBs is the same idea at row level: `UPDATE ... WHERE version = expected`

# Pitfalls
- **ABA problem**: a value goes A→B→A between your load and your CAS, so the CAS succeeds on stale assumptions (classic in lock-free stacks, where a node gets freed and reused). Fixes: tagged/versioned pointers (double-width CAS), hazard pointers, epoch-based reclamation.
- **Contention**: every CAS needs the line in M state ([[MESI protocol]]). Under heavy contention CAS loops can be *slower* than a mutex. Mitigate with backoff or sharded counters.
- **Memory ordering**: CAS gives atomicity, not visibility of *other* writes. Choose `acquire`/`release` deliberately.

# Related
- [[Locks]] · [[Semaphore]] · [[Coffman Conditions]] · [[CPU Cache]]
