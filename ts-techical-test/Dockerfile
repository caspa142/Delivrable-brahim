# Use the official Node.js image as the base image
FROM node:lts-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install project dependencies and TypeScript as a development dependency
RUN npm install && npm install typescript -D

# Copy the source code to the container
COPY . .

# Build the TypeScript code
RUN npm run build

# Expose the port that the application will run on
EXPOSE 3000

# Start the application
CMD ["node", "dist/app.js"]

