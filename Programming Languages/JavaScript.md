---
tags: [ai-edited]
---
Function call stack, Heap, Event loop 

## Event Loop - Callback queue 
Jobs like IO calls, events, timer 
Asynchronous, concurrent programming 
When call stack is empty, pull more jobs from the call back queue 

## Call stack 
LIFO stack of execution frames. JS is single-threaded, so a long synchronous function blocks the event loop (no rendering, no callbacks). **Microtasks** (Promises) drain before the next macrotask (timers, I/O).

# Related
- [[NodeJS]] · [[React]] · [[AsyncIO]]
