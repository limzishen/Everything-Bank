---
tags: [ai-edited]
---
https://middleware.io/blog/server-health-monitoring/
# Things to look out for 
## System Recourse 
- Network activity 
- Service responsiveness
- CPU load 
- Disk usage 

## Application performance 
- Response time 
- throughput 
- Error rates 
- Response Queue 

# CPU load 
High cpu load indicates you might have to scale your servers up 
Low cpu load indicates you might not need the server

# Memory usage (RAM)
Track memory leaks or low RAM 
Application slowdown can be caused by memory pressure: swapping to disk, GC pauses ([[Java Garbage Collection]]), OOM kills

# Disk Space 
Full utilisation of disk space can crash the system 

# Disk IO Performance 
Check disk read write speed 
IO performance might be a bottle neck in the system 

# Network activity 
Check for HTTP error messages 
5xx errors - server errors 
4xx errors - client errors (400 bad request, 401/403 auth, 404 not found, **429** rate limited). DNS failures don't produce HTTP codes at all.
Throughput - 
DNS resolution time - Time taken for DNS response
Packet Loss - congestion or Hardware failure 
Connection errors 
Bandwidth usage - DDOS, or data loss

# Frameworks
- **RED** (per service): Rate, Errors, Duration (latency **percentiles**, p50/p99, not averages).
- **USE** (per resource): Utilisation, Saturation, Errors.
- Tooling: Prometheus + Grafana (metrics), OpenTelemetry (traces), ELK/Loki (logs).

# Related
- [[Kubernetes]] · [[Network]] · [[microservice vs monolith]]
