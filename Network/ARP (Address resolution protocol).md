---
tags: [ai-edited]
---
A table to map ip address to mac address 
Typically used on LAN 
Tells to which device on the LAN should go 


# Protocol for address resolution
1. Host wants to send to IP `10.0.0.5` on its subnet and checks its ARP cache (`ip neigh`).
2. Miss → **broadcast** `Who has 10.0.0.5? Tell 10.0.0.2` to `ff:ff:ff:ff:ff:ff`.
3. Owner **unicasts** a reply with its MAC. The requester caches it (entries age out after seconds to minutes).
4. For an off-subnet IP, the host ARPs for the **default gateway's** MAC instead. ARP never crosses routers.

- **Gratuitous ARP**: announce your own IP→MAC (failover, duplicate-IP detection).
- **ARP spoofing**: ARP has no authentication, so attackers can poison caches for MITM. Mitigated with Dynamic ARP Inspection.
- IPv6 replaces ARP with **NDP** (ICMPv6 neighbour solicitation).
- Lives at the Link/Network boundary ([[Network]]). Each [[Network Namespaces|network namespace]] has its own ARP table.


