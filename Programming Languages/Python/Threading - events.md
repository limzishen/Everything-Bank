---
tags: [ai-edited]
---
# Pre no-GIL 
With the global interpreter lock, only one part of the python bytecode can run at once
So multiple cpu threads cant run all together all at once 

With GIL, CPU heavy bound task is slow but efficient for IO bound task to free up the cpu process to run something else 
Because of the GIL, multiple CPU threads can't run Python bytecode in parallel unless you use multiprocessing (but multiprocessing can't share memory across processes by default). See [[GIL]].

# no GIL 
allow for parallel of data sharing and multiple threads running at once with shared memory 

# Lock 
`threading.Lock()` prevents other threads from entering the critical section (it doesn't stop them running other code)
The lock primitive does not belong to any thread: any thread can release it. `RLock` *is* owned and re-entrant. Compare with a mutex vs [[Semaphore]] in [[Locks]].

# Events 
Event is used like a signal to communicate across threads 

**False = "not ready yet, stop and wait"**
**True = "good to go, keep moving"**

![[Pasted image 20260604144204.png]]

## .wait()
**`.wait()`** Called by a thread that needs to pause. Checks the flag — if `True`, passes straight through. If `False`, parks the thread and costs no CPU until `.set()` wakes it up. Optionally takes a timeout so it doesn't wait forever.

If flag is `True`, its as if wait is ignored everything else will just run 
## .set()
Flips the flag to `True`. Any thread currently parked on `.wait()` wakes up and continues running. This is how you send the "go" signal. 
## .clear()
Flips the flag back to `False`. Doesn't affect any currently running threads — they're already gone. It just means the next thread to call `.wait()` will block. Used to re-arm the event for the next cycle.

```
import threading
import time

# Initialize the event (starts as False)
gate_open = threading.Event()

def worker_thread(name):
    while True:
        print(f"Worker {name}: Waiting for the gate to open...")
        gate_open.wait()  # Blocks here if flag is False
        
        print(f"Worker {name}: Gate is open! Performing task...")
        time.sleep(1)  # Simulate work
        print(f"Worker {name}: Task finished.\n")

# Start the worker
t1 = threading.Thread(target=worker_thread, args=(1,), daemon=False)
t1.start()


# Main thread controlling the flow
for i in range(2):
    time.sleep(2)
    print(f"Main: Opening gate for Round {i+1} ---")
    gate_open.set()     # Flag becomes True -> Worker runs
    
    time.sleep(0.5)     # Give the worker a moment to pass through
    
    print(f"Main: Closing gate after Round {i+1} ---")
    gate_open.clear()   # Flag becomes False -> Next wait() will block
    
```

# Related
- [[GIL]] · [[Python Multiprocessing vs Multithreading]] · [[Producer Consumer Problem]] · [[AsyncIO]]
