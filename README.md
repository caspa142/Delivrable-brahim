# Delivrable-brahim

## Repository Content

- :white_check_mark: **Typescript Application and Dockerfile**
  - Source code for the Typescript application.
  - Dockerfile for building and running the application.
  <img src="https://img.icons8.com/color/48/000000/docker.png" width="20" height="20"/> <img src="https://img.icons8.com/color/48/000000/typescript.png" width="20" height="20"/>

- :white_check_mark: **Kubernetes Deployments**
  - `deployment.yml`: Configuration file for deploying the application in Kubernetes.
  - `service.yml`: Configuration file for setting up the service.
  <img src="https://img.icons8.com/color/48/000000/kubernetes.png" width="20" height="20"/>

- :white_check_mark: **Terraform Script**
  - `kubernetes.tf`: Terraform script that sets up a Kubernetes namespace and deploys the Docker container.
  <img src="https://img.icons8.com/color/48/000000/terraform.png" width="20" height="20"/>

- :white_check_mark: **Helm Chart**
  - `ts-techical-test-app`: Helm chart for the application.


- :white_check_mark: **Automated Helm Deployment**
  - `helm-kubernetes.tf`: Automates the deployment of the Helm chart.

This repository contains all the necessary components to run the project and manage its deployments. Enjoy exploring!


## Task one: Dockerizing Your TypeScript Application

This guide will help you containerize your TypeScript application using Docker. Follow these steps to get started:

1. **Create a Dockerfile**

   In the root directory of your project, create a Dockerfile to define how the Docker image for your application should be built. Below is an example Dockerfile:

   ```Dockerfile
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

   ```

   Save this Dockerfile in your project's root directory. It uses the official `node:lts-alpine` image as the base, installs project dependencies, copies the source code, builds TypeScript, and starts the application.

2. **Build the Docker Image**

   Open a terminal, navigate to your project's directory, and run the following command to build the Docker image:

   ```bash
   docker build -t ts-techical-test-app .
   ```

   This command builds an image named `ts-techical-test-app`. Ensure that you have Docker installed on your machine.

3. **Run the Docker Container**

   Once the image is built, you can run a Docker container from it using the following command:

   ```bash
   docker run -p 3000:3000 ts-techical-test-app
   ```

   This command runs a container from the image and maps port 3000 in the container to port 3000 on your host machine.

Your TypeScript application is now Dockerized and accessible at `http://localhost:3000`. You can customize the Dockerfile or use a different base image if needed, but `node:lts-alpine` is a good choice for lightweight Node.js applications.
```

This README provides clear instructions for Dockerizing your TypeScript application using Markdown with appropriate headers, lists, and a code block for the Dockerfile. You can also customize it further, and feel free to add icons as per your preferences.
