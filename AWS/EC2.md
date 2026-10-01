---
tags: [ai-edited]
---
A service by amazon to allow user to rent for compute 

Allow for better scaling

# Key concepts
- **Instance type**: family + size, e.g. `t3.micro` (burstable), `c7g` (compute, Graviton/ARM), `r7i` (memory), `g5` (GPU).
- **AMI** (Amazon Machine Image): the OS + software template an instance boots from.
- **EBS**: network-attached block storage volume; persists independently of the instance. **Instance store** is local NVMe and is lost on stop.
- **Security Group**: stateful, instance-level firewall (allow rules only). Lives inside a [[VPC (Virtual private cloud)|VPC]] subnet.
- **Auto Scaling Group** + **ELB/ALB**: horizontal scaling and health-checked load balancing.
- **User data**: bootstrap script run on first boot.

# Pricing models
- **On-demand**: pay per second, no commitment.
- **Reserved / Savings Plans**: 1–3 year commitment, up to ~70% off.
- **Spot**: spare capacity, up to ~90% off, can be reclaimed with a 2-minute warning. Only for fault-tolerant / batch work.

# EC2 vs alternatives
- **ECS/EKS on EC2 or Fargate**: run containers ([[Docker]], [[Kubernetes]]) instead of managing VMs.
- **Lambda**: no servers to manage, event-driven, 15-minute limit.

Back to [[AWS]]
