---
tags: [ai-edited]
---
Goal: minimise response time (for interactive jobs) **and** turnaround time (like STCF), without knowing job lengths in advance.
Issue: knowledge about the processes is incomplete, so MLFQ *learns* from observed behaviour.

Each level is a different priority, and the priority of each job varies over time.

# Rules (OSTEP ch. 8)
1. If Priority(A) > Priority(B), A runs.
2. If Priority(A) = Priority(B), A and B run [[Process Scheduling|round-robin]] using that queue's time slice.
3. A new job enters at the **highest** priority.
4. Once a job uses up its **time allotment** at a level (cumulative, regardless of how many times it gave up the CPU), it moves **down** one level.
5. After period **S**, **boost** all jobs to the top queue.

# Why each rule exists
- Rules 3 + 4: short/interactive jobs finish (or block on I/O) near the top, so it approximates SJF. Long CPU-bound jobs sink.
- Rule 4 counts *total* time at a level, so a job can't **game** the scheduler by yielding just before its slice ends.
- Rule 5 prevents **starvation** of long jobs and handles jobs that change from CPU-bound to interactive.

# Tuning
- Higher queues get shorter slices (e.g. 10 ms), lower queues longer (100+ ms).
- Choosing S is "voodoo constants" territory: too long starves jobs, too short hurts interactive response.
- Real implementations: Solaris TS class, Windows NT, early BSD. Linux uses [[Random Scheduling|CFS / EEVDF]] instead.

# Related
- [[Process Scheduling]] · [[Context Switch]] · [[Process]]
