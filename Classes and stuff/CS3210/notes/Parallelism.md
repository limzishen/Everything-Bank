# How to achieve parallelism 
## Bit Level 
The instructions processes the entire word at once instead of single bits 
## Instruction Level (ILP) 
Pipelined instruction processing 
### Superscalar 
Allow multiple instruction to pass through the same stage 
**The instructions are from the same execution flow**
The superscalar processor takes in independent instructions and process it parallel.  
![[Pasted image 20260906194450.png]]

Increase the number of ALU (Arithmetic Logic Processor) to allow for more instruction to be computed in parallel 
## Threads Level (TLP)
### SMT (Simultaneous Multithreading)
![[Pasted image 20260906200957.png]]

**SMT** fills **idle execution slots** left by one thread's poor ILP with another thread's ready instructions. It's latency hiding + utilization recovery.

SMT architecture share execution unit like: 
- ALU 
- FPU (Floating point unit)
- load store memory access 
- SIMD/Vector unit 
- Cache
- TLB unit 

## Process Level Parallelism 
![[Pasted image 20260906203004.png]]

Achieves true parallelism. 


