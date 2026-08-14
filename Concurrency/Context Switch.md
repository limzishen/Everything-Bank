# Context Switching - threads 
## When 
- Preemptive switch 
	- Forced by kernel
	- Higher priority task runs first look [[Multi-level Feedback Queue]]
- Voluntary Switch
	- IO bound traffic


## Mechanism
1. Kernel SysCall/interrupt 
2. Save thread A context into kernel stack -> Save kernel stack in to thread control block
3. Scheduler picks up the next threads 
4. Restore the incoming thread B context from Kernel stack from TCB
5. Switch Kernel Stack to thread B's
6. Back to user mode

## Cost 
L!/L2 cache is wiped 
Kernel user transition overhead 


## Kernel stack 
Used during kernel interrupts 
Thread context are stored here 

## Thread context 
1. Thread register 
2. Stack pointer 
3. Programme counter 
4. Cpu States 
5. Floating Point Calculation states

