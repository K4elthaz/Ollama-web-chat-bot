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

# Install Ollama CLI
RUN curl -o ollama https://ollama.com/download/OllamaCLI-linux \
    && chmod +x ollama \
    && mv ollama /usr/local/bin/

# Download the LLaMA 3.2 model
RUN ollama pull llama3.2

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

# Expose ports for both services
EXPOSE 10000 11434

# Use the shell script to start both the Ollama server and Node.js app
CMD ["./start.sh"]
