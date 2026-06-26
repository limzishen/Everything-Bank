# Things I still have to work on 
Look into Instrumenting AsyncIO 
Figure out IO blocking library in Python Socket 

# Testing on Loguru 
## Bad testing practices used on loguru 

```python
# Example of bad test in loguru 
def test_enqueue():
    x = []

    def sink(message):
        time.sleep(0.1)
        x.append(message)

    logger.add(sink, format="{message}", enqueue=True) # spawns a multiprocessing thread
    logger.debug("Test") # Main thread pass the value to the worker thread
    assert len(x) == 0 # this assert in the main thread checks if the value is not written into the log yet
    # This check happens while the worker thread is sleeping 
    
    logger.complete() # main thread check if the logging is completed
    assert len(x) == 1
    assert x[0] == "Test\n"
```

```python
# bad test cases where it test if multiprocessing object exist
def test_using_multiprocessing_directly_if_context_is_none():
    logger.add(lambda _: None, enqueue=True, context=None)
    assert multiprocessing.get_start_method(allow_none=True) is not None
```

## Test still having issues that are unresolved 
tests/test_coroutine_sink.py (asyncIO)
tests/test_multiprocessing.py (Most likely because multiprocessing pool is not instrumented) - test expects multiprocessing object and not prays object
This can be replaced on loguru testing 

tests/test_threading.py (slow and there is one failure)
tests/test_reinstall.py 


# General Concerns
1. Changing log level changes output (Consistent if log levels are the same)
2. Multiprocessing does not share memory - mapping to thread might cause issues
3. Timing using global time lock (Abit out of scope) - need to gain more context 
4. 

# Python NativeIO blocking 
1. FileIO 
2. NetworkIO (socket, ssl, client etc.)
3. Subprocess (multiprocessing) - instrumented 
4. Console 
5. concurrent.Futures 

# Todos 
1. instrument - socket 
2. fix multiprocessing 
3. Time.sleep()
4. Investigate log levels 
5. Ask charles how to deal with exploding scheduling points 
6. 