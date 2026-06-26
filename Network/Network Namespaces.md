Used by [[Docker]], Kubernetes pod 

The namespace is an instance of the networking stack 
The kernel handles the networking stack, storing the protocol and machinery to process the packets 

So: **each network namespace gets its own complete, independent network stack.** Its own interfaces, own routing table, own ARP table, own iptables rules, own socket tables, own port space, own `/proc/net`. 


## Interfaces (the devices)

The **network interfaces** themselves: `lo`, `eth0`, veth ends, bridges, bond/VLAN interfaces, `tun`/`tap`, WireGuard `wg0`, etc. This is the most fundamental thing it holds, with one critical property from earlier: **an interface belongs to exactly one network namespace at a time.** It's not copied across namespaces — it _lives in_ one, and you _move_ it between them. That's the whole mechanism behind veth wiring (create the pair, migrate one end into the container's netns). Each interface carries its own config: its **IP addresses** (v4 and v6), MAC, MTU, up/down state, and per-interface stats (packet/byte counters).

## Routing (where packets go)

- **Routing tables** — _all_ of them. Not just the `main` table; the `local` table and any custom policy-routing tables too. This is what the L3 routing logic consults to pick the next hop. (The container's "default route → 172.17.0.1 gateway" from the bridge diagram lives here.)
- **Routing policy rules** (`ip rule`) — the database that decides _which_ routing table to use for a given packet. Policy routing is fully per-namespace.

## Neighbor resolution

- **The [[ARP (Address resolution protocol)]] / neighbor table** — the IP→MAC mappings (`ip neigh`), covering ARP for IPv4 and NDP for IPv6. Each namespace resolves its neighbors independently.

## Firewall, NAT, and connection state

- **The full netfilter ruleset** — `iptables` / `nftables`, every table: `filter`, `nat`, `mangle`, `raw`. So the SNAT/DNAT rules from the port-publishing discussion are namespace-local — each container can have its own firewall and NAT rules that don't touch anyone else's.
- **The conntrack (connection-tracking) table** — the stateful record of in-flight connections that NAT and stateful firewalling depend on. Per-namespace, so two containers' connection states never collide.

## Sockets and ports (the L4 endpoints)

- **The socket tables and port number space** — every bound socket, every listening port, every established TCP/UDP connection. This is the one with the cleanest observable consequence: because the port space is per-namespace, **two containers can both `bind()` port 80 with zero conflict** — they're separate number spaces entirely. Each genuinely owns its own `:80`.

## Tunables (the knobs)

- **Network sysctls** — the entire `net.*` tree under `/proc/sys/net/` is namespaced. `net.ipv4.ip_forward`, the TCP buffer sizes, `tcp_syncookies`, reverse-path filtering — each namespace has its own independent copy. This matters more than it sounds: a bridge can only _route_ between containers if `ip_forward` is on _in the relevant namespace_, so this knob is part of what makes the whole topology work.

## Traffic control and lower-level state

- **qdiscs / traffic control** (`tc`) — the queueing disciplines attached to interfaces (rate limiting, shaping, prioritization). Per-interface, so per-namespace.
- **Bridge forwarding tables (FDB)**, **IPsec/XFRM state** (security associations and policies), and **multicast/IGMP membership** — the more specialized state, all namespace-local too.

## The kernel's exposed view

- **`/proc/net/` and `/sys/class/net/`** — these aren't separate state so much as the _window_ onto everything above. Inside a namespace, reading `/proc/net/tcp` or `/proc/net/route` or listing `/sys/class/net/` shows _that namespace's_ interfaces, sockets, and routes — which is exactly how tools like `ss`, `netstat`, and `ip` end up namespace-aware for free. They just read these files, and the files reflect whichever netns the process is in.