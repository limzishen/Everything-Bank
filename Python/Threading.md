# Pre no-GIL 
With the global interpreter lock, only one part of the python bytecode can run at once
So multiple cpu threads cant run all together all at once 

With GIL, CPU heavy bound task is slow but efficient for IO bound task to free up the cpu process to run something else 
Because of GIL, multiple cpu threads can run in parallel unless you use multiprocessing (but multiprocessing cant share memory across threads)
