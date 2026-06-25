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



