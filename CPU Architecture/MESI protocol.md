---
tags: [ai-edited]
---
Protocol to ensure data coherence and consistency across mutiple cpu cores 
![[Pasted image 20260414221830.png]]

# States (per cache line, per core)
| State | Meaning | Dirty? | Other copies? |
| --- | --- | --- | --- |
| **M**odified | Only this core has it, and it has been written | yes | no |
| **E**xclusive | Only this core has it, matches memory | no | no |
| **S**hared | Clean, may be in other cores' caches | no | possibly |
| **I**nvalid | Line is not usable | – | – |

# Key transitions
- **Read miss**: other cores have it → load as **S**; nobody has it → load as **E**.
- **Write while in E**: silently go to **M** (no bus traffic, which is why E exists).
- **Write while in S**: broadcast an *invalidate* (Read-For-Ownership); all other copies go to **I**, writer goes to **M**.
- **Another core reads a line held in M**: the owner writes it back (or forwards it) and both end up in **S**.
- **Another core writes**: the local copy goes to **I** → the next access is a *coherence miss*.

# Consequences
- Writes to a line shared by many cores cost a cross-core round trip: this is what makes [[Locks | reader–writer locks]] and shared atomic counters scale badly ([[Left Right Crate]]).
- **False sharing**: see [[CPU Cache]].
- Coherence ≠ consistency: MESI keeps *one line* coherent; ordering across *different* addresses is the memory model (store buffers, fences, `std::memory_order`).
- Variants: **MESIF** (Intel, adds Forward) and **MOESI** (AMD, adds Owned, so dirty lines can be shared without a write-back).

# Related
- [[CPU Cache]] · [[Compare and Swap (CAS)]] · [[Parallelism]]
