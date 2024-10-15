#!/bin/bash

# Start Ollama in the background
ollama serve --model llama3.2 &

# Start the Node.js app
node index.js
