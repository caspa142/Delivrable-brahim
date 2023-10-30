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



##  Task 2: Kubernetes Setup
In this task, you will set up a local Kubernetes environment to deploy your TypeScript application. Follow these steps to get started:
To do this task, I used K3S which is a highly available, certified Kubernetes distribution designed for production workloads in unattended and resource-constrained.

###   1. Write a Kubernetes Deployment YAML File

To deploy your application to Kubernetes, you need a Deployment YAML file that specifies how your app should be deployed, including services and any necessary configurations. Below is an example YAML file for your reference:

```yaml
# deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ts-techical-test-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ts-techical-test-app
  template:
    metadata:
      labels:
        app: ts-techical-test-app
    spec:
      containers:
      - name: ts-techical-test-app
        image: ts-techical-test-app:latest
        imagePullPolicy: IfNotPresent  # Use the locally available image
        ports:
          containerPort: 3000
```

### 2. Deploy to Local Kubernetes Cluster

Now that you have your Deployment YAML file ready, you can deploy this configuration to your local Kubernetes cluster.

- Use the following command to deploy your application:

  ```bash
  kubectl apply -f deployment.yml
  ```

  This will create the necessary resources in your Kubernetes cluster.

### 3. Verify Application Accessibility Using Port Forward

To ensure that your application is accessible, you can use port forwarding. The `service.yml` file defines a Kubernetes Service that allows you to access your application.

```yaml
# service.yml
apiVersion: v1
kind: Service
metadata:
  name: ts-techical-test-service
spec:
  selector:
    app: ts-techical-test-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
```

- Apply this Service configuration using the following command:

  ```bash
  kubectl apply -f service.yml
  ```

- To access your application, use port forwarding:

  ```bash
  kubectl port-forward service/ts-techical-test-service 8080:80
  ```

  Your application should now be accessible at `http://localhost:8080`.

These steps will help you deploy your TypeScript application on your local Kubernetes cluster and verify its accessibility using port forwarding.

Happy Kubernetes deployment!

## Bonus Task: Terraform Script for Kubernetes Deployment

In this bonus task, I wrote a Terraform script to set up a Kubernetes namespace and deploy your Docker container into it. Here's how to accomplish it:

## 1. Write a Terraform Script

Create a Terraform script that defines the Kubernetes resources you need. Below is my Terraform script :

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "brahim2"  # Namespace name
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "ts-techical-test-app-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ts-techical-test-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "ts-techical-test-app"
        }
      }

      spec {
        container {
          name           = "ts-techical-test-app"
          image          = "ts-techical-test-app:latest"  # Docker image to deploy
          image_pull_policy = "IfNotPresent"  # Set the imagePullPolicy
        }
      }
    }
  }
}```


2. Apply the Terraform Script

Use the following steps to apply the Terraform script:

    Make sure you have Terraform installed on your local machine.

    Initialize the Terraform configuration:


```
terraform init
```
Create an execution plan:

```

terraform plan
```
Apply the Terraform script to create the Kubernetes namespace and deployment:

```

    terraform apply
```
3. Verify the Kubernetes Deployment

After applying the Terraform script, you should have a Kubernetes namespace and a deployment running your Docker container. You can verify this by checking your Kubernetes cluster using the kubectl commands.

This Terraform script simplifies the process of setting up your Kubernetes environment and deploying your Docker container.

Enjoy your Kubernetes deployment!


