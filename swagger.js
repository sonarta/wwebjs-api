const swaggerAutogen = require('swagger-autogen')({ openapi: '3.0.0', autoBody: false })

const outputFile = './swagger.json'
const endpointsFiles = ['./src/routes.js']

// Get base path from environment or default to '/'
const basePath = process.env.BASE_PATH || '/'

const doc = {
  info: {
    title: 'WWebJS API',
    description: 'API wrapper for WhatsAppWebJS'
  },
  servers: [
    {
      url: basePath,
      description: 'default server'
    },
    {
      url: `http://localhost:3000${basePath}`,
      description: 'localhost server'
    }
  ],
  securityDefinitions: {
    apiKeyAuth: {
      type: 'apiKey',
      in: 'header',
      name: 'x-api-key'
    }
  },
  produces: ['application/json'],
  tags: [
    {
      name: 'Session',
      description: 'Handling multiple sessions logic, creation and deletion'
    },
    {
      name: 'Client',
      description: 'All functions related to the client'
    },
    {
      name: 'Message'
    }
  ],
  definitions: {
    StartSessionResponse: {
      success: true,
      message: 'Session initiated successfully'
    },
    StopSessionResponse: {
      success: true,
      message: 'Session stopped successfully'
    },
    StatusSessionResponse: {
      success: true,
      state: 'CONNECTED',
      message: 'session_connected'
    },
    RestartSessionResponse: {
      success: true,
      message: 'Restarted successfully'
    },
    TerminateSessionResponse: {
      success: true,
      message: 'Logged out successfully'
    },
    TerminateSessionsResponse: {
      success: true,
      message: 'Flush completed successfully'
    },
    ErrorResponse: {
      success: false,
      error: 'Some server error'
    },
    NotFoundResponse: {
      success: false,
      error: 'Not found error'
    },
    ForbiddenResponse: {
      success: false,
      error: 'Invalid API key'
    },
    GetSessionsResponse: {
      success: true,
      result: ['session1', 'session2']
    }
  }
}

swaggerAutogen(outputFile, endpointsFiles, doc)
