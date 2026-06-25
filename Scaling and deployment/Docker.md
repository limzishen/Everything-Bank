# Docker Image 
A standalone executable file used to create a Docker container 
Docker images are immutable, sharable and portable 
Able to deploy the same image in multiple location
Read only
# Docker Container 
The runtime environment with all the necessary components like code and dependencies 
Mimics the functionalities of different OSs but limited to it only. Does not have kernel capabilities like hardware control and 

# Docker base image 
Foundation for your docker image 
Select the right image depending on your needs 

```dockerfile
FROM node:20-alpine   # ← this is your base image
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
```

Each images are layered on top of each other based on your requirements 
### OS images 
`ubuntu`, `debian`, `alpine`, `fedora`
You will have to install everything else by yourself 

### Language base image 
`node`, `python`, `golang`, `openjdk` 
Bases images with the runtime language already installed 

You can have several `FROM` in a single file but you can only build the container from one depending on your hardware/container specification 

# Setting up Docker file 
```dockerfile
# Use an official base image
FROM node:20-alpine
 
# Set the working directory inside the container
WORKDIR /app
 
# Copy package files first (for layer caching)
COPY package*.json ./
 
# Install dependencies
RUN npm ci --only=production
 
# Copy the rest of the application
COPY . .
 
# Expose the port the app listens on
EXPOSE 3000

# Command to run when the container starts
CMD ["node", "src/index.js"]
```

## Building an Image 
Updates the image with the new changes to the 
```dockerfile 
# Build from the current directory, tag as myapp:1.0
docker build -t myapp:1.0 .
```

### Build cache 
**Good order (cache-friendly):**  COPY package*.json ./ → RUN npm ci → COPY . .
**Bad order (cache-busting):**  COPY . . → RUN npm ci  (any code change re-runs npm ci)
# Docker Volumes 
A persistent storage for data 
Typically used to store static files, db data 

# Container networking 
Each container contains it own [[Network Namespaces]]
The containers communicate through the docker bridge 
Set up the bridge through docker-compose files
![[Pasted image 20260625111407.png]]

