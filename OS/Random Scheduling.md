## Random scheduling 
Give a process a random number 
pick a random number 
run the process with the random number 

## Stride Scheduling 
**Stride** - a value obtained by dividing a arbitrary large number by the process tickets

Have a stride counter for each process
1. Pick the process with the lowest stride counter 
2. run the process and add the process stride to the stride counter 
3. repeat 
```
curr = remove_min(queue); // pick client with min pass schedule(curr); // run for quantum curr->pass += curr->stride; // update pass using stride insert(queue, curr); // return curr to queue
```
![[Pasted image 20260223002336.png]]

## CFS (Completely Fair Scheduling)
Divide sched_latency value by n (number of processes)
If greater than min_granularity then use the value else min 
Run each process based on the time slice 
increase virtual runtime of the process while its running 
pick the process with the lowest v_runtime

its like round robin but without fix time slice 

Can customise the process time slice by assigning niceness 
![[Pasted image 20260223005133.png]]

V_runtime also increase differently based on the runtime 
![[Pasted image 20260223005158.png]]

Use a red black tree to keep track of the order of the job vruntime 

