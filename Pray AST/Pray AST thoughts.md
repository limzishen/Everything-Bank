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
    assert len(x) == 0 # this asserts in the main thread checks if the value is not written into the log yet
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
tests/test_coroutine_sink.py 
tests/test_multiprocessing.py (Most likely because multiprocessing pool is not instrumented) - test expects multiprocessing object and not prays object
tests/test_threading.py (slow and there is one failure)
tests/test_reinstall.py 


# General Concerns
1. Changing log level changes output 
2. Randomized seed if starting seeds are not defined 
3. each pytest runs does not clean up seeds - it should be in documentation 
4. 