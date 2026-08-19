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
Threads in contention spins until it is able to access the lock. No context required
Look Peterson Algorithm

## Usage 
Typically used when context windows are short and context switch are most constly than just waiting. 
