# Kubernetes (K8s)

 - **Self-healing.** A container crashes, K8s restarts it. A whole node dies, K8s notices and reschedules everything that was on it onto healthy nodes.

- **Scheduling / bin-packing.** You've got 20 machines and 200 containers with different CPU/memory needs. K8s organizes the 

- **Service discovery + load balancing.** Containers are ephemeral — they die, restart, get rescheduled, and their IPs change constantly. K8s gives you a stable virtual IP and DNS name for a _Service_, and routes to whatever pods are currently healthy behind it. Your code talks to `payments-service`, not an IP that's valid for 4 minutes.

- **Rolling deploys + rollbacks.** Ship a new version by gradually replacing old pods with new ones, health-checking as it goes, and automatically rolling back if the new ones fail to come up. No downtime, no manual choreography.