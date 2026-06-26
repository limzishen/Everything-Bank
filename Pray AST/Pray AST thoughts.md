# Things I still have to work on 
Look into Instrumenting AsyncIO 
Figure out IO blocking library in Python 

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

## Test still having issues that are unresolved 
tests/test_coroutine_sink.py 
tests/test_multiprocessing.py (Most likely because multiprocessing pool is not instrumented) 
tests/test_threading.py (slow and there is one failure)
tests/test_reinstall.py 


