#!/bin/bash

# Start Ollama server in the background
ollama serve > /usr/src/app/ollama_server.log 2>&1 &
Ollama_pid=$!

# Pull the llama3.2 model before starting the Ollama server
echo "Pulling the llama3.2 model..."
if ollama pull llama3.2; then
    echo "Model pulled successfully."
else
    echo "Failed to pull the model. Check Ollama logs."
    exit 1
fi


# Give the Ollama server a few seconds to start
echo "Waiting for Ollama server to start..."
sleep 10  # Wait for 10 seconds before checking

# Check if Ollama server is responsive
for i in {1..10}; do
    if curl -s http://127.0.0.1:11434/api/tags; then
        echo "Ollama server is up and running."
        break
    else
        echo "Waiting for Ollama server to respond... Attempt $i/10"
        sleep 3  # Wait a bit before the next check
    fi
done

# Check if we got a successful response
if ! curl -s http://127.0.0.1:11434/; then
    echo "Ollama server did not start properly."
    echo "Check the log file for details: /usr/src/app/ollama_server.log"
    exit 1
fi

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:11434"

# Start the Node.js app
node index.js
