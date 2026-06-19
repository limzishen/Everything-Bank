Have a counter to keep track of available resources 
Like in [[Producer Consumer Problem]], where the size of the buffer is the resource 

each wait() decrements the counter 
The counter basically acts as a permit counter, how many thread are able to run 
If the counter is 0 nothing run, new task are added into a queue 

Use signal() to release the permit and takes a queued task to run 


