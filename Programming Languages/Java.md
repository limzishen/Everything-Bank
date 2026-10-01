---
tags: [ai-edited]
---
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
Mark all objects **reachable** from the GC roots
Sweep (free) everything left unmarked

![[Pasted image 20251209205705.png]]
Use GC Roots to determine which are unreacheble

Generational Garbage collection 
Splits the heap into multiple heap 
The younger generation triggers garbage collection more often 
The tenured generation heap needs less frequent collection because most objects die young (the **weak generational hypothesis**), so the survivors are likely to live long.

Details and collector choice: [[Java Garbage Collection]]

# Related
- [[Java Garbage Collection]] · [[Memory]] · [[Python Memory Model]]
