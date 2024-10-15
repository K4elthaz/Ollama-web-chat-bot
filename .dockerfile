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

# Download the LLaMA 3.2 model (ensure you have access to the model via Ollama)
RUN ollama pull llama3.2

# Set working directory
WORKDIR /usr/src/app

# Copy the package.json and install dependencies for your Node.js app
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port for the Express app
EXPOSE 3000

# Start both Ollama and your Express app
CMD ["npm", "start"]
