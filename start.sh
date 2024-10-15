#!/bin/bash

# Start Ollama server in the background
ollama serve > /usr/src/app/ollama_server.log 2>&1 &
Ollama_pid=$!

# Check if Ollama server started successfully
if ! ps -p $Ollama_pid > /dev/null; then
    echo "Failed to start Ollama server."
    exit 1
fi

# Wait for Ollama to start
echo "Waiting for Ollama to start..."
sleep 10  # Adjust this time if needed

# Check if Ollama server is responsive
for i in {1..10}; do
    if curl -s http://127.0.0.1:11434/health; then
        echo "Ollama server is up and running."
        break
    else
        echo "Waiting for Ollama server to respond... Attempt $i/10"
        sleep 3  # Wait a bit before the next check
    fi
done

# Check if we got a successful response
if ! curl -s http://127.0.0.1:11434/health; then
    echo "Ollama server did not start properly."
    exit 1
fi

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:11434"

# Start the Node.js app
node index.js
