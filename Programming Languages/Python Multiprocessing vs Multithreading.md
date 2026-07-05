# Multithreading
Multiple threads shares the same code but run on different register and stack 
Good for IO bound processes 
Interleave task on he same processor 
Python GIL thread prevents true parallel processing

## Memory Sharing 
### Queue/Pipe
1. An OS pipe (multiprocessing.connection.Pipe) — the actual channel bytes flow through.
2. A collections.deque buffer + a feeder thread — living in the sending process.
3. Locks/semaphores — a write lock, a read lock, and a BoundedSemaphore tracking size.

![[Pasted image 20260703011152.png]]

- `_wlock` — a write lock serializing the feeder threads / senders writing to the pipe, so two processes putting at the same time don't interleave their bytes on the wire. (On some platforms writes below PIPE_BUF are atomic, but the lock guarantees it generally.)
- `_rlock` — a read lock serializing consumers reading from the pipe, so two processes doing get() don't each grab half of one message.
- `_sem`— a BoundedSemaphore implementing maxsize (and the Full/Empty logic).
### Value 
Allow C primitive to be used as a shared state about multiprocessing thread 
Python objects are barred from the c primitive 

```

```
### Manager 

### Fork 

# Multiprocessing
More overhead compared to multithreading 
Does not share the same heap due to GIL lock \