const express = require('express');
const { Ollama } = require('ollama');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
app.use(cors());
const ollama = new Ollama({
    baseUrl: 'http://0.0.0.0:11434', // Connect to Ollama's default port
  });
  
// app.use(express.static('public'));
app.use(express.json());

app.post('/api/chat', async (req, res) => {
  const { message } = req.body;

  try {
    const response = await ollama.chat({
      model: 'qwen2:0.5b',
      messages: [
        {
          role: 'system',
          content:
            'You are a licensed therapist trained in cognitive-behavioral therapy. Your role is to provide support and answer questions about mental health issues only. If a user asks about topics unrelated to mental health, gently redirect them back to relevant subjects.',
        },
        { role: 'user', content: message }, // User message
      ],
    });

    res.json({ reply: response.message.content });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while processing your request.' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running at 0.0.0.0:${PORT}`);
});
