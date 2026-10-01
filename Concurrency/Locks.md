---
tags: [ai-edited]
---
# Mutex 
A lock where only one thread can lock and unlock 

## Usage 
Use it to protect a share mutable state where the critical section maybe long

## Mechanics
Any thread that tries to access a locked section, the scheduler will move it to a wait queue associated with the mutex 

# Semaphore 
refer to [[Semaphore]]
n=1 semaphore is similar to a mutex but lack ownership and priority inheritance

## Usage 
- **Counting semaphore:** limit concurrent access to **N identical resources** (connection pool of 5, N slots in a buffer).
- **Signaling / synchronization:** thread A `post`s, thread B `wait`s — cross-thread event notification, producer/consumer handoff. A mutex _can't_ do this because unlock must come from the owner.

# Spinlocks 
Threads in contention spin until they can take the lock, so there is no context switch. Usually implemented with [[Compare and Swap (CAS)|CAS]] / test-and-set.
Look Peterson Algorithm and [[Lamport Bakery algorithm]]

## Usage 
Typically used when critical sections are short and a [[Context Switch]] is more costly than just waiting. Bad on oversubscribed cores (the spinner burns the time slice the lock holder needs).

# Reader–writer lock
Many concurrent readers **or** one writer. Readers still *write* the shared reader count, so the lock's cache line bounces between cores ([[MESI protocol]]). That's why [[Left Right Crate]] exists.

# Related
- [[Coffman Conditions]] · [[Producer Consumer Problem]] · [[Optimistic locking vs Pessimistic locking]] · [[Threading - events]]
