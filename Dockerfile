# Use lightweight Alpine-based Node.js image
FROM node:18-alpine

# Create non-root user and group for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S -u 1001 -G nodejs nodejs

# Set working directory
WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./

# Install only production dependencies (smaller image size)
RUN npm ci --only=production

# Copy application code
COPY . .

# Change ownership of the app directory to non-root user
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose the port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
