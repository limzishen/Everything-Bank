# Pre no-GIL 
With the global interpreter lock, only one part of the python bytecode can run at once
So multiple cpu threads cant run all together all at once 

With GIL, CPU heavy bound task is slow but efficient for IO bound task to free up the cpu process to run something else 
Because of GIL, multiple cpu threads can run in parallel unless you use multiprocessing (but multiprocessing cant share memory across threads)

# no GIL 
allow for parallel of data sharing and multiple threads running at once with shared memory 

# Lock 
threading.lock() prevents other thread from running
The lock primitive does not belong to any thread 

# Events 
Event is used like a signal to communicate across threads 
## .wait()
place the thread on alert, waiting for other thread to tell them the next action 
## .set()
tells rest of the threads that are on wait to star 

## .clear()
Blocks all incoming wait 

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
