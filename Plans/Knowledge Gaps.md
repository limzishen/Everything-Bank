---
tags: [hub, todo]
---
Concepts that are missing or only stubbed in this vault. Links in this list point to notes that **don't exist yet**: they show as greyed-out nodes in the graph view, and clicking one creates the note. Tick the box once the note is written in your own words.

Compiled from the [[Overview.canvas|Overview canvas]], [[Detailed Plans]], [[General Plans]], [[Summer 2026 Plans]], [[General notes while studying]], and the stub notes removed in the Oct 2026 clean-up. Ordered roughly by how much the existing notes depend on them.

# High priority (existing notes already lean on these)
- [ ] [[Condition Variables]]: used in [[Producer Consumer Problem]] variants and phase 3 of [[Concurrency Learning plan]]
- [ ] [[Deadlock Livelock Starvation]]: only covered inside [[Coffman Conditions]]; the canvas lists them separately
- [ ] [[Reader Writer Problem]]: referenced by [[Locks]], [[Left Right Crate]], [[Project Idea#C++ Exchange Engine]]
- [ ] [[Atomics and Memory Ordering]]: `std::memory_order`, happens-before, fences; needed for [[Compare and Swap (CAS)]] and lock-free work
- [ ] [[Thread Pool]]: capstone in [[Concurrency Learning plan]]
- [ ] [[TCP]]: handshake, flow vs congestion control, Nagle, TIME_WAIT; flagged most important in [[Detailed Plans]]
- [ ] [[UDP]]: and multicast (market data feeds)
- [ ] [[Sockets and IO Multiplexing]]: sockets API, select/epoll/kqueue, io_uring. A stated weakness in [[Summer 2026 Plans]] and the root of [[pray-ast fails on native blockingIO]]
- [ ] [[System Calls]]: user vs kernel mode, trap mechanics
- [ ] [[RAII]]: plus [[Smart Pointers]] and [[Move Semantics]] (incl. copy elision). Partly started in [[Key Operations]] / [[Function Param and Return]]

# System design
- [ ] [[Availability and Fault Tolerance]]: redundancy, replication, failover, SLAs/nines. Ref: https://medium.com/@vndee.huynh/system-design-note-03-availability-dbbb78e7853a
- [ ] [[Distributed Consistency]]: CAP/PACELC, eventual vs strong, quorums, Raft
- [ ] [[Load Balancing]]: L4 vs L7, algorithms, health checks
- [ ] [[Rate Limiting]]: token bucket, leaky bucket
- [ ] [[Kafka]]: partitions, consumer groups, offsets (beyond [[SQS (Simple Queue System)|SQS]])
- [ ] [[REST vs GraphQL vs gRPC]]
- [ ] [[WebSockets]]
- [ ] [[Authentication]]: sessions vs JWT, OAuth2/OIDC

# CPU / hardware
- [ ] [[Pipelining and Hazards]]: [[Datapath and Control Signals]] only covers single-cycle
- [ ] [[Branch Prediction]]
- [ ] [[Virtualization]]: hypervisors, VMs vs containers ([[Docker]])

# Languages
- [ ] [[OOP]]: four pillars + SOLID
- [ ] [[Coroutines]]: Python generators → async ([[AsyncIO]]), Go goroutines
- [ ] [[Python Runtime Optimisation]]: specialising adaptive interpreter, 3.13 JIT
- [ ] [[Entity Component System]]

# DSA
- [ ] [[Binary Lifting]]
- [ ] [[Sparse Table]]
- [ ] [[Segment Tree]]
- [ ] [[Skip List]]
- [ ] [[Monotonic Stack]], [[Bit Masking]], DP and greedy patterns ([[General Plans]])
- (source list: [[Concepts im unfamiliar with]])

# Data / ML
- [ ] [[NumPy]]: basics + broadcasting ([[Pandas]] exists)
- [ ] ML: [[Linear Regression]], [[XGBoost]], [[LSTM]]

# Benchmarking
- [ ] [[Benchmarking Concurrent Structures]]: ops/sec, latency percentiles, contention scaling, `perf`

Back to [[Home]]
