FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl wget

# Install Node.js and NPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install Ollama (ensure this is the correct command for your setup)
RUN curl -O https://ollama-install-url.sh && bash install-ollama.sh

# Copy the Node.js application
COPY . /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
RUN npm install

# Expose both the Node.js and Ollama ports
EXPOSE 10000 11434

# Use a shell script to start both Ollama and Node.js
CMD ["./start.sh"]
