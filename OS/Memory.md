---
tags: [ai-edited]
---
# Address Space 
A private, dedicated memory provided for each process 


# Virtualisation of memory 
![[Pasted image 20260223010945.png]]
## Why virtualised 
| **Problem**         | **Non-Virtualized Reality**           | **Virtualized Solution**                            |
| ------------------- | ------------------------------------- | --------------------------------------------------- |
| **Crashing**        | One app can overwrite another.        | **Total Isolation:** Apps can't see each other.     |
| **Fragmentation**   | Memory is "holey" and unusable.       | **Contiguity:** Apps see one solid block.           |
| **Waste**           | Every app loads its own copy of code. | **Sharing:** One physical copy, many virtual views. |
| **Physical Limits** | Out of RAM = System Crash.            | **Flexibility:** Uses Disk space as "extra" RAM.    |

# How virtualisation works (paging)
- Virtual address = `page number | offset` (4 KB pages → 12-bit offset).
- The per-process **page table** maps virtual pages to physical frames. The MMU walks it on every access.
- The **TLB** caches translations. A miss costs a multi-level page walk, and a process switch flushes it unless tagged ([[Context Switch]]).
- **Page fault**: page not resident → kernel loads it from disk/swap, or allocates on first touch / copy-on-write ([[Fork]]).

# Address space layout (low → high)
code (text) → data/BSS → **heap** (grows up, `malloc`/`brk`/`mmap`) → … → mmap region / shared libs → **stack** (grows down). Each [[Thread]] gets its own stack in the same address space.

# Related
- [[Process]] · [[CPU Cache]] · [[Python Memory Model]] · [[Java]]
