---
tags: [ai-edited]
---
Single threaded Cooperative Concurrency 
Coroutine managed by Python 
Used for IO bound workload 
Event loop to keep track of the what should run. A coroutine runs until it hits `await` on something not ready, which suspends it and gives control back to the loop. Underneath, the loop waits on sockets with `selectors` (epoll/kqueue), like Node's event loop ([[NodeJS]]).

**A blocking call (`time.sleep`, `requests.get`) inside a coroutine stalls the whole loop.** Use `await asyncio.sleep` or `loop.run_in_executor` / `asyncio.to_thread`.

# Why is AsyncIO faster than threads 
1. Scheduled by the language instead of the OS (Does not utilise the costly Syscall interruption and the OS Preemptive Scheduling)
2. Lower cost of Memory initialisation 
	- Thereads have a fixed stack of virtualised memory reserved
	- Threads have their own private stack 
	- A coroutine is just a heap-allocated frame object (~KBs), so 100k concurrent tasks is fine
3. lower context switch cost 
	- No need to reset python stack memory and perform context switch 
	- Everything for AsyncIo lives as Python Frame Object in the event loop

# When should you not use AsyncIo 
1. Workload is mostly CPU bounded. Does not give you a better advantage
2. There are minimal concurrency with the code anyways. Use threads for simplicity
3. 3rd libraries that are synchronous, adding asyncIO on top is gonna break stuff

# Related
- [[GIL]] · [[Threading - events]] · [[Python Execution Model]] · [[pray-ast fails on native blockingIO]]
