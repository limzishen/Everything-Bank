---
tags: [ai-edited]
---
# Advantages of Kubernetes (K8s)

 - **Self-healing.** A container crashes, K8s restarts it. A whole node dies, K8s notices and reschedules everything that was on it onto healthy nodes.
- **Scheduling / bin-packing.** You've got 20 machines and 200 containers with different CPU/memory needs. K8s places (bin-packs) containers onto machines based on their CPU/memory requests and limits
- **Service discovery + load balancing.** K8s gives you a stable virtual IP and DNS name for a _Service_, and routes to whatever pods are currently healthy behind it. Your code talks to `payments-service`, not directly to an IP 
- **Rolling deploys + rollbacks.** Ship a new version by gradually replacing old pods with new ones, health-checking as it goes, and automatically rolling back if the new ones fail to come up. No downtime, no manual choreography.
- **Horizontal autoscaling**, secrets/config injection, and a storage abstraction so stateful stuff survives reschedules round it out.

# Core objects
- **Pod**: smallest unit, 1+ containers sharing a [[Network Namespaces|network namespace]] and volumes.
- **Deployment** → ReplicaSet → Pods: declarative desired state, rolling updates.
- **Service**: stable virtual IP/DNS in front of pods (ClusterIP / NodePort / LoadBalancer).
- **Ingress**: L7 HTTP routing into services.
- **ConfigMap / Secret**: injected config.
- **Control loop**: controllers keep reconciling actual state toward desired state (that's what makes it self-healing).

# Related
- [[Docker]] · [[microservice vs monolith]] · [[Server monitoring]] · [[EC2]]
