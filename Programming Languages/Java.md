Function execution

# Code execution 
Stack and heap 
**Stack**
Method calls are store in stack 
The local variables of the method are also stored in the stack 

**heap**
heap stores the instance variable
heap will store referenced type variable

**metaspace**
Stores static variable

# Garbage Collector 
Mark and sweep 
Mark all the unreachable objects in heap 
Garbage collects them all 

![[Pasted image 20251209205705.png]]
Use GC Roots to determine which are unreacheble

Generational Garbage collection 
Splits the heap into multiple heap 
The younger generation triggers garbage collection more often 
The tenured generation heap will need less garbage collection as the 