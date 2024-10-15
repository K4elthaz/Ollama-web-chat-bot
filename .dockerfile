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

# Install Ollama CLI using the recommended installation script
RUN curl -fsSL https://ollama.com/install.sh | sh

# Check if Ollama CLI was installed correctly
RUN /usr/local/bin/ollama --version > /usr/src/app/ollama_install.log 2>&1

# Download the LLaMA 3.2 model
RUN /usr/local/bin/ollama pull llama3.2 > /usr/src/app/ollama_model.log 2>&1  # Log the model download

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
