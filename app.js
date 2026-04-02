const express = require('express');
const app = express();

const PORT = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('CI/CD Pipeline App is running 🚀');
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

app.get('/employees', (req, res) => {
  res.json([
    { id: 1, name: 'Arshit', role: 'DevOps Engineer' },
    { id: 2, name: 'Rahul', role: 'Backend Developer' }
  ]);
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
