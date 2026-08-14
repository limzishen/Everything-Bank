Single threaded Cooperative Concurrency 
Coroutine managed by Python 
Used for IO bound workload 
Event loop to keep track of the what should run. If something is blocked push it to the back

# Why is AsyncIO faster than threads 
1. Scheduled by the language instead of the OS (Does not utilise the costly Syscall interruption and the OS Preemptive Scheduling)
2. Lower cost of Memory initialisation 
	- Thereads have a fixed stack of virtualised memory reserved
	- Threads have their own private stack 
	- 
3. lower context switch cost 
	- No need to reset python stack memory and perform context switch 
	- Everything for AsyncIo lives as Python Frame Object in the event loop

# When should you not use AsyncIo 
1. Workload is mostly CPU bounded. Does not give you a better advantage
2. There are minimal concurrency with the code anyways. Use threads for simplicity
3. 3rd libraries that are synchronous, adding asyncIO on top is gonna break stuff 

