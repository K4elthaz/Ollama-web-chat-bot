#!/bin/bash

# Start Ollama in the background
ollama serve --model llama3.2 &

# Wait for Ollama to start (optional)
sleep 5  # Adjust the duration as needed

# Start the Node.js app
node index.js
