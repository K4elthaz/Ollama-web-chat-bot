#!/bin/bash

# Start Ollama server in the background and log output
ollama serve > ollama.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to start Ollama server."
    exit 1
fi

# Wait for Ollama to start
echo "Waiting for Ollama to start..."
sleep 50 

# List available models and log output
echo "Listing available models..."
ollama list >> ollama.log 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to list models."
    exit 1
fi

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:11434"

# Start the Node.js app
node index.js
