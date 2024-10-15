#!/bin/bash

# Start Ollama server in the background and log output
echo "Starting Ollama server..."
ollama serve > ollama.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to start Ollama server."
    exit 1
fi

# Wait for Ollama to start with retries
echo "Waiting for Ollama to start..."
for i in {1..20}; do
    if curl -s http://localhost:11434/ > /dev/null; then
        echo "Ollama server is running at http://localhost:11434."
        break
    fi
    echo "Waiting... Attempt $i/20"
    sleep 5
done

# Check if Ollama server started successfully
if ! curl -s http://localhost:11434/ > /dev/null; then
    echo "Ollama server did not start in time. Check ollama.log for details."
    echo "Contents of ollama.log:"
    cat ollama.log  # Show the log contents here for better visibility
    exit 1
fi

# Log available models
echo "Listing available models..."
ollama list >> ollama.log 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to list models. Check ollama.log for details."
    echo "Contents of ollama.log:"
    cat ollama.log  # Show the log contents here for better visibility
    exit 1
fi

# Log the Ollama server URL
echo "Ollama server should be running at http://localhost:11434"

# Start the Node.js app
echo "Starting Node.js application..."
node index.js >> ollama.log 2>&1  # Redirect Node.js app output to log
