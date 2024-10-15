#!/bin/bash

# Start Ollama server in the background
ollama serve --model llama3.2 &
if [ $? -ne 0 ]; then
    echo "Failed to start Ollama server."
    exit 1
fi

# Wait for Ollama to start
echo "Waiting for Ollama to start..."
sleep 5 

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:10000"

# Start the Node.js app
node index.js
