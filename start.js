const { exec } = require('child_process');
const util = require('util');

const execPromise = util.promisify(exec);

const startServers = async () => {
    try {
        // Pull the model using Ollama
        const { stdout, stderr } = await execPromise('npx ollama pull llama3.2');
        console.log(stdout);
        console.log("Model pulled successfully. Starting servers...");

        // Start the Express server
        const expressProcess = exec('node index.js'); // Adjust if your main file is different

        expressProcess.stdout.on('data', (data) => {
            console.log(`Express: ${data}`);
        });

        expressProcess.stderr.on('data', (data) => {
            console.error(`Express Error: ${data}`);
        });

        // Start Ollama server
        const ollamaProcess = exec('npx ollama serve');

        ollamaProcess.stdout.on('data', (data) => {
            console.log(`Ollama: ${data}`);
        });

        ollamaProcess.stderr.on('data', (data) => {
            console.error(`Ollama Error: ${data}`);
        });
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
};

startServers();
