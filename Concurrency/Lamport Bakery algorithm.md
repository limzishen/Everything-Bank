---
tags: [ai-edited]
---
# Goals of a good concurrency algo 
No starvation - if another process spam request, other process should also be able to enter
Mutual exclusion - no 2 process can be in the critical section together 
Progress - Another process can enter when needed

# Idea
Like taking a numbered ticket at a bakery: each thread takes a number one larger than any number it sees, and the lowest number goes first. Ties are broken by thread id. It only needs plain reads/writes, with **no atomic RMW** like [[Compare and Swap (CAS)|CAS]].

# Algorithm (N threads)
```
bool choosing[N] = {false}
int  number[N]   = {0}

lock(i):
    choosing[i] = true
    number[i] = 1 + max(number[0..N-1])
    choosing[i] = false
    for j in 0..N-1:
        while choosing[j]: spin                       # wait until j has its ticket
        while number[j] != 0 and (number[j], j) < (number[i], i): spin

unlock(i):
    number[i] = 0
```

# Properties
- Mutual exclusion, deadlock freedom, and **FCFS fairness** (no starvation), so it satisfies all three goals above.
- Tolerates non-atomic reads of `number[j]`, which is the clever part, and the reason `choosing` exists.
- Costs: O(N) scan per acquire, tickets grow without bound, and on modern CPUs it needs memory fences because store buffers reorder writes. In practice it's a teaching tool. Real locks use atomics ([[Locks]]).

Compare with Peterson's algorithm (2 threads only).

# Related
- [[Locks]] · [[Coffman Conditions]]
