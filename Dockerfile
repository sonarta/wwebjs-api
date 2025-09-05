# Use the official Node.js Debian image as the base image
FROM node:22-bookworm-slim AS base

# Set environment variables
ENV CHROME_BIN="/usr/bin/chromium" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production" \
    PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium"

WORKDIR /usr/src/app

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

# Create a non-root user and set up directories
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && mkdir -p /home/pptruser/sessions \
    && chown -R pptruser:pptruser /home/pptruser \
    && chmod -R 755 /home/pptruser

# Copy only production dependencies from deps stage
COPY --from=deps /usr/src/app/node_modules ./node_modules

# Copy application files
COPY . .

# Set permissions for the app directory
RUN chown -R pptruser:pptruser /usr/src/app \
    && chmod -R 755 /usr/src/app

# Switch to non-root user
USER pptruser

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
