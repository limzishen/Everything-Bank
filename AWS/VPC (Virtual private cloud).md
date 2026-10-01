---
tags: [ai-edited]
---
A **Virtual Private Cloud (VPC)** is a logically isolated, private network environment created within a public cloud. It gives you full control over your cloud networking—allowing you to define IP address ranges, set up subnets, configure route tables, and establish security firewalls while taking advantage of scalable public cloud infrastructure

![[Pasted image 20260625112907.png]] 

# Internet Gateway  
Public access gateway 

# Public Subnet
Contains the load balancers and routes packets and calls into the private subnet. "Public" means its route table has `0.0.0.0/0 → Internet Gateway`.

# Private Subnet
No route to the IGW. App servers ([[EC2]]) and databases (RDS) live here. Outbound internet access (e.g. `apt update`) goes through a **NAT Gateway** placed in the public subnet.

# Security Groups vs NACLs
| | Security Group | Network ACL |
| --- | --- | --- |
| Attached to | instance / ENI | subnet |
| State | **stateful** (return traffic auto-allowed) | **stateless** (must allow both directions) |
| Rules | allow only | allow + deny, evaluated in order |

# Related
- Under the hood this is the same idea as Linux [[Network Namespaces]]: isolated routing tables, interfaces, and firewall rules. See also [[Network]] and [[AWS]].
