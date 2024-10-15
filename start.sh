#!/bin/bash

# Start Ollama server in the background
ollama serve > /usr/src/app/ollama_server.log 2>&1 &
Ollama_pid=$!

if [ $? -ne 0 ]; then
    echo "Failed to start Ollama server."
    exit 1
fi

# Wait for Ollama to start
echo "Waiting for Ollama to start..."
sleep 10  # Adjust this time if needed

# Check if Ollama is running
if ! ps -p $Ollama_pid > /dev/null; then
    echo "Ollama server did not start."
    exit 1
fi

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:11434"

# Start the Node.js app
node index.js
