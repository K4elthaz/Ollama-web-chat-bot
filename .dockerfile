# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    build-essential \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for your Express app)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Ollama CLI without GPU detection
RUN curl -fsSL https://ollama.com/install.sh | sh -s -- --cpu \
    && echo "Ollama installed successfully"

# Set working directory for the Node.js app
WORKDIR /usr/src/app

# Copy package.json and install Node.js dependencies
COPY package*.json ./ 
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy the shell script to start both services
COPY start.sh .

# Make the shell script executable
RUN chmod +x start.sh

# Expose the ports
EXPOSE 3000 11434

# Use the shell script to start both the Ollama server and Node.js app
CMD ["bash", "start.sh"]
