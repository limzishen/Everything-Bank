Priority Change testing 
# Algorithm 
1. Assign the n priority values d, d+ 1, . . . , d+n randomly to the n threads (we reserve the lower priority values 1, . . . ,(d − 1) for change points).
2. Pick d − 1 random priority change points k1, . . . , kd−1 in the range [1, k]. Each ki has an associated priority value of i.
3. Schedule the threads by honoring their priorities. When a thread reaches the i-th change point (that is, when it executes the ki-th

# Benefits over random walk 
