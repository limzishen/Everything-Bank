# What it is
When there are N number of threads producing some info and consuming information 
how do you coordinate the flow of information between the threads 

# How it works 
**Shared state**
```
buffer[N]           // fixed-size buffer holding N slots
in  = 0             // index where producer inserts next
out = 0             // index where consumer removes next

// Three synchronization primitives:
semaphore empty = N // counts empty slots (starts full of space)
semaphore full  = 0 // counts filled slots (starts with nothing)
mutex    mtx        // protects buffer access (binary lock)
```

**Producer**
```
produce():
   while true:
		item = produceItem()      // make something (outside critical section)

        wait(empty)               // block if no empty slots; else decrement
        wait(mtx)                 // acquire exclusive access to buffer

        buffer[in] = item         // --- critical section ---
        in = (in + 1) mod N

        signal(mtx)               // release buffer
        signal(full)              // announce one more filled slot
```

**Consumer**
```
consume():
    while true:
        wait(full)                // block if buffer empty; else decrement
        wait(mtx)                 // acquire exclusive access to buffer

        item = buffer[out]        // --- critical section ---
        out = (out + 1) mod N

        signal(mtx)               // release buffer
        signal(empty)             // announce one more empty slot

        consumeItem(item)         // process it (outside critical section)
```