const { exec } = require('child_process');

// Pull the model using Ollama
exec('ollama pull llama3.2', (err, stdout, stderr) => {
    if (err) {
        console.error(`Error pulling model: ${stderr}`);
        process.exit(1); // Exit if the model pull fails
    }

    console.log(stdout);
    console.log("Model pulled successfully. Starting servers...");

    // Start the Express server
    const expressProcess = exec('node index.js'); // Adjust if your main file is different

    // Log Express server output
    expressProcess.stdout.on('data', (data) => {
        console.log(`Express: ${data}`);
    });

    expressProcess.stderr.on('data', (data) => {
        console.error(`Express Error: ${data}`);
    });

    // Start Ollama server
    const ollamaProcess = exec('ollama serve');

    // Log Ollama server output
    ollamaProcess.stdout.on('data', (data) => {
        console.log(`Ollama: ${data}`);
    });

    ollamaProcess.stderr.on('data', (data) => {
        console.error(`Ollama Error: ${data}`);
    });
});
