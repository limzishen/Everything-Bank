https://www.youtube.com/watch?v=tND-wBBZ8RY
# Issue
**Mutex** 
requires writer and reader to aquire locks on the memory to read or write 
This is slow because you can only read one at a time

**Reader writer locks**
Allow multiple reader to read concurrently 
Even though performance might seems good for High ratio of reads to writes 
There are problems with this due to [[cache]]
[[MESI protocol]] 
Each time a reader tries to acquire a lock, it will need to access the global variable to update the count and update the cache in each L3 cache in each core 
The cross core validation is really expensive
Reader writer requires a write i.e. writing to the global count of readers

# How Left Right Crate solves this kinda 
Have 2 section of data. 
A pointer to point to the data that can be read 
The write will write to the other crate of data 
once the writer finishes writing, flip the pointer. 

# problems with this 
![[Pasted image 20260414235324.png]]

