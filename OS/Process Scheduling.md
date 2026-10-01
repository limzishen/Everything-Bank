---
tags: [ai-edited]
---

# Metrics 
Turn around time = Completion time - arrival time 
Response time = First time process is run - Arrival time 

# FIFO 
Slow and inefficient as a big job can block the short job from finishing 

# Shortest Job First (SJF) / Shortest Time to Completion First (STCF)
SJF is non-preemptive. STCF is the preemptive version (a newly arrived shorter job preempts the current one).
Optimal to minimise the Turn around time 
Do the shortest task first 
Issue: 
OS does not know when a job is going to finish first 
## Preemptive scheduling 
The ability to stop one process temporarily and run another process 

# Round Robin 
Execute a process every time slice 
Minimise response time 
Cost of switching is amortised 
Shorter time slice better round robin but worse overhead cost for switching 
Issue: 
Bad turnaround time 

# Task Overlapping 
Instead of waiting for IO request to run, run a different process to maximise utilisation rate 

# Without knowing job lengths
- [[Multi-level Feedback Queue]] (learns from past behaviour)
- Proportional share: lottery / stride / CFS ([[Random Scheduling]])

# Related
- [[Process]] · [[Context Switch]] · [[Random Scheduling]]
