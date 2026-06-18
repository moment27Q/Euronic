require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const Anthropic = require('@anthropic-ai/sdk').default;

const app = express();
const PORT = 4000;
const JWT_SECRET = 'euronic_dev_secret_2024';

app.use(cors());
app.use(express.json());

// Almacenamiento en memoria (solo para desarrollo)
const users = new Map();

app.post('/auth/register', async (req, res) => {
  const { email, password, fullName } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y contraseña son requeridos' });
  }

  if (users.has(email)) {
    return res.status(409).json({ message: 'Este correo ya está registrado' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  users.set(email, { email, password: hashedPassword, fullName: fullName || '' });

  return res.status(201).json({ message: 'Cuenta creada correctamente' });
});

app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y contraseña son requeridos' });
  }

  const user = users.get(email);
  if (!user) {
    return res.status(401).json({ message: 'Correo o contraseña incorrectos' });
  }

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    return res.status(401).json({ message: 'Correo o contraseña incorrectos' });
  }

  const token = jwt.sign({ email: user.email, name: user.fullName }, JWT_SECRET, { expiresIn: '7d' });
  return res.status(200).json({ token });
});

app.post('/ai/chat', async (req, res) => {
  const { message, history = [] } = req.body;

  if (!message) {
    return res.status(400).json({ message: 'El mensaje es requerido' });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ message: 'API key no configurada en el servidor' });
  }

  try {
    const client = new Anthropic({ apiKey });

    const messages = [
      ...history.map(h => ({ role: h.role, content: h.content })),
      { role: 'user', content: message },
    ];

    const response = await client.messages.create({
      model: 'claude-haiku-4-5-20251001',
      max_tokens: 1024,
      system: 'Eres un asistente de traducción y ayuda general de la app Euronic AI. Responde siempre en el idioma del usuario. Sé conciso y amigable.',
      messages,
    });

    const reply = response.content[0].text;
    return res.status(200).json({ reply });
  } catch (err) {
    console.error('Error Anthropic:', err.message);
    return res.status(500).json({ message: 'Error al contactar la IA' });
  }
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
