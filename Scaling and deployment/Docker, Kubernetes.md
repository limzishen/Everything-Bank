### **Docker**

- **What it is:** A platform that lets you package applications and their dependencies into _containers_.
    
- **Key idea:** Instead of running directly on your OS, apps run in isolated, lightweight environments that are portable.

- **Why useful:**

- Eliminates “it works on my machine” issues.

- Containers start fast and use fewer resources than full virtual machines.

- Makes deployment consistent across dev, test, and production.
### **Kubernetes (K8s)**

- **What it is:** An open-source system for **orchestrating and managing containers** (often Docker containers).
    
- **Key idea:** Docker runs containers, but Kubernetes manages _many containers across many machines_.
    
- **Why useful:**
    
    - Handles scaling (up/down containers based on load).
        
    - Automates deployment and rollbacks.
        
    - Ensures high availability (restarts crashed containers, balances traffic).
        
    - Works across clusters of servers.