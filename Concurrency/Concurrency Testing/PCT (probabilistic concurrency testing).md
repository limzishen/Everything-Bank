---
tags: [ai-edited]
---
**Probabilistic Concurrency Testing** (Burckhardt et al., ASPLOS 2010). A randomised scheduler that changes thread priorities at random points.
# Algorithm 
1. Assign the n priority values d, d+ 1, . . . , d+n randomly to the n threads (we reserve the lower priority values 1, . . . ,(d − 1) for change points).
2. Pick d − 1 random priority change points k1, . . . , kd−1 in the range [1, k]. Each ki has an associated priority value of i.
3. Schedule the threads by honoring their priorities (always run the highest-priority runnable thread). When a thread reaches the i-th change point (that is, when it executes the ki-th step of the run), change its priority to i.

n = threads, k = total steps, d = bug depth (number of ordering constraints needed to trigger the bug).

# Benefits over random walk
- **Guarantee**: each run finds a bug of depth d with probability ≥ **1 / (n · k^(d−1))**. Most real bugs have small d (1–3), so a few thousand runs are enough.
- A random walk picks the next thread uniformly at every step, so the probability of hitting a specific *long-range* ordering decays exponentially with k. PCT spends randomness only on d−1 change points.
- Runs threads mostly sequentially, so it doesn't drown in useless interleavings.

Used as a scheduler policy in [[Pray AST]] (`--sched pct`). Change points are shared across processes in the multiprocessing work ([[Pray AST Multiprocessing]]).

# Related
- [[Testing]] · [[heap access]] · [[Multiprocessing granularity]]
