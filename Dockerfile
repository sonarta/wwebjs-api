# Use the official Node.js Debian image as the base image
FROM node:22-bookworm-slim AS base

# Set environment variables
ENV CHROME_BIN="/usr/bin/chromium" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production" \
    PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium" \
    SESSIONS_PATH="/app/sessions"

WORKDIR /app

FROM base AS deps

COPY package*.json ./

RUN npm ci --only=production --ignore-scripts

# Create the final stage
FROM base

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-freefont-ttf \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    chromium \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create and set up sessions directory with full permissions
RUN mkdir -p /app/sessions \
    && chmod -R 777 /app/sessions

# Copy only production dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy application files
COPY . .

# Set permissions for the app directory
RUN chmod -R 755 /app

# Run as root to avoid permission issues
# USER pptruser

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
