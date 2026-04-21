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

