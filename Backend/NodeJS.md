---
tags: [ai-edited]
---
Single threaded, event-driven and non IO blocking model 

# Core Architecture 
Single threaded runtime management 
Task are sent to the event queue 
Task are separated into IO blocking and Non IO blocking event 

Non IO blocking task are executed immediately
IO blocking task are sent to the event loop

> [!warning] Correction
> More precisely: JS runs on one thread, and I/O is handed to **libuv**. Network I/O uses the OS's async APIs (epoll/kqueue/IOCP). File system, DNS, crypto and zlib use libuv's **thread pool** (default 4 threads, `UV_THREADPOOL_SIZE`). When the work completes, its *callback* is queued and the event loop runs it once the call stack is empty. CPU-heavy JS still blocks everything, so use `worker_threads` for that.
![[Pasted image 20260624105624.png]]
The phases are processed in this looping order 
Each of the phases have a FIFO queue

# Microtasks vs macrotasks
After each callback, Node drains `process.nextTick` callbacks first, then Promise microtasks, before moving to the next phase (timers → pending → poll → check (`setImmediate`) → close).

# Related
- [[ExpressJs]] · [[NestJS]] · [[JavaScript]] · [[AsyncIO]]
