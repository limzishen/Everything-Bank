---
tags: [ai-drafted]
---
Small, fast SRAM between the core and DRAM. Exists because DRAM latency (~100 ns) is ~100–300× a register access. Different from application-level caching — see [[Caching]].

# Hierarchy (typical x86 desktop, order of magnitude)
| Level | Size | Latency | Scope |
| --- | --- | --- | --- |
| L1d / L1i | 32–48 KB each | ~4 cycles | private per core |
| L2 | 1–2 MB | ~12–15 cycles | private per core |
| L3 (LLC) | 8–64 MB | ~40–60 cycles | **shared** across cores |
| DRAM | GBs | ~200+ cycles | shared |

# Cache line
- Unit of transfer = **64 bytes** (x86, most ARM). Touching 1 byte pulls in the whole line.
- **Spatial locality**: iterate contiguous memory (arrays > linked lists).
- **Temporal locality**: reuse data while it's still hot.

# Mapping
- **Direct-mapped**: each address maps to exactly one slot → conflict misses.
- **N-way set associative**: address picks a set, line can sit in any of N ways (L1 is usually 8–12 way).
- Address split: `tag | set index | offset (6 bits for 64 B)`.

# Miss types (3 Cs + 1)
- **Compulsory** – first touch.
- **Capacity** – working set > cache.
- **Conflict** – too many lines map to the same set.
- **Coherence** – another core wrote the line → invalidated (see [[MESI protocol]]).

# Write policies
- **Write-back** (normal for CPUs): write to cache, mark dirty, flush on eviction.
- **Write-through**: write to cache and next level immediately.

# Why concurrency programmers care
- **False sharing**: two threads write *different* variables on the *same* line → the line ping-pongs between cores even though no data is shared. Fix: pad/align hot per-thread data to 64 B (`alignas(64)` / `std::hardware_destructive_interference_size`).
- **Shared counters are expensive**: every write needs the line in Modified state on the writer's core, so other cores' copies get invalidated. This is the reader-count bottleneck in RW locks described in [[Left Right Crate]].
- Context switches don't flush caches, but the incoming thread finds them **cold** (see [[Context Switch]]).

# Related
- [[MESI protocol]] · [[Parallelism]] · [[Memory]] · [[Datapath and Control Signals]]
