const express = require('express');
const app = express();
const port = process.env.PORT || 80;

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'ECS API Service is running!',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    environment: process.env.APP_NAME || 'the-awesome-app'
  });
});

// API endpoints
app.get('/api', (req, res) => {
  res.json({
    message: 'Hello from ECS API!',
    path: '/api',
    timestamp: new Date().toISOString(),
    instance: process.env.HOSTNAME || 'unknown'
  });
});

app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    service: 'ECS API Service',
    version: '1.0.0',
    node_version: process.version,
    environment: {
      app_name: process.env.APP_NAME,
      port: process.env.PORT,
      hostname: process.env.HOSTNAME
    }
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    path: req.originalUrl,
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 ECS API Service listening on port ${port}`);
  console.log(`Environment: ${process.env.APP_NAME || 'the-awesome-app'}`);
}); 