---
tags: [ai-edited]
---
# TCP/IP model (what the internet actually uses)
## Application
1. Http
2. DNS
3. SMTP
4. FTP

## Transport
1. TCP (reliable, ordered, connection-oriented, congestion control)
2. UDP (unreliable datagrams, no handshake, used for low latency: DNS, video, market data multicast)

## Network
1. IP (routing between networks)

## Link
1. CSMA/CD
2. Pass the mic (taking-turns protocols)
3. TDMA/FDMA
4. [[ARP (Address resolution protocol)]] (IP → MAC on the local network)

# OSI model (7 layers, merged from the old `OSI model` note)
![[Pasted image 20260625110809.png]]
Mapping: OSI 5–7 (session/presentation/application) → TCP/IP Application, 4 → Transport, 3 → Network, 1–2 → Link.

# Related
- [[Network Namespaces]] · [[VPC (Virtual private cloud)]] · [[Docker]] · [[Server monitoring]]
