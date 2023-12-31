# Delivrable-brahim

## Repository Content

- :white_check_mark: **ts-techical-test : Typescript Application and Dockerfile**
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

   In the root directory of your project, create a Dockerfile to define how the Docker image for your application should be built. Below is the Dockerfile I used:

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

   ```
   docker build -t ts-techical-test-app .
   ```

   This command builds an image named `ts-techical-test-app`. Ensure that you have Docker installed on your machine.

3. **Run the Docker Container**

   Once the image is built, you can run a Docker container from it using the following command:

   ```
   docker run -p 3000:3000 ts-techical-test-app
   ```

   This command runs a container from the image and maps port 3000 in the container to port 3000 on your host machine.



##  Task 2: Kubernetes Setup
In this task, you will set up a local Kubernetes environment to deploy your TypeScript application. Follow these steps to get started:
To do this task, I used K3S v1.27.6 which is a highly available, certified Kubernetes distribution designed for production workloads in unattended and resource-constrained.

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

  ```
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
}

```

2. Apply the Terraform Script

Use the following steps to apply the Terraform script:


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


## Bonus task: 2 Setting Up a Helm Chart for Your Application
The folder containing the helm chart is ts-techical-test-app.
In this guide, we'll walk you through the process of creating a Helm Chart for your application and defining configurable parameters using Helm.

###  Step 1: Create a Helm Chart for Your Application

You can use the `helm create` command to create a Helm Chart skeleton. Here's how you can create a Helm Chart for your application:

```shell
helm create ts-technical-test-app
```
This will create a directory structure with the necessary files for your Helm Chart.

### Step 2: Package Your Kubernetes Resources in the Helm Chart
Inside the ts-technical-test-app directory, you'll find a templates directory where you can place your Kubernetes resource YAML files. You can copy your Kubernetes Deployment YAML into this directory.

For example, if your Deployment YAML is named deployment.yaml, you can copy it to the templates directory.

### Step 3: Define Configurable Parameters in Your Helm Chart
In your Helm Chart's values.yaml file, you can define configurable parameters. For example, you can define parameters for replica count, service type, and any other values you want to make configurable. Here's an example of what your values.yaml file might look like:

```yaml

replicaCount: 1
service:
  type: ClusterIP
```
Customize these parameters according to your application's requirements. Defining configurable parameters in your Helm Chart allows for flexibility and reusability in your Kubernetes deployments.




## Bonus Task: 3 Deploy the Helm Chart Through Terraform


### 1. Write a Terraform Script

Create a Terraform script that defines the Kubernetes resources you need. Below is an example Terraform script I had developed:


```
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "brahim2"  # Namespace name
  }
}

resource "helm_release" "example" {
  name       = "ts-technical-test-app"
  chart      = "ts-technical-test-app"  # Replace with your Helm Chart name
  namespace  = kubernetes_namespace.example.metadata[0].name
  values = [
    file("~/ts-technical-test-app/values.yaml"),  # Path to your Helm Chart values file
  ]
}
```
### 2 Customize the Terraform Configuration
Open the Terraform configuration file (helm-kubernetes.tf) and customize it to match your deployment requirements. In the provided Terraform script, you'll find the following key components:

provider "helm": This configuration sets up Helm to work with your Kubernetes cluster.
provider "kubernetes": This provides access to your Kubernetes cluster.
resource "kubernetes_namespace": Defines the Kubernetes namespace where your deployment will reside.
resource "helm_release": Specifies the Helm Chart deployment, including the name, chart name, and values file.
Modify the values and configuration according to your specific Helm Chart and deployment needs. Ensure that you specify the correct paths and namespaces.

### 3: Initialize Terraform
Run the following command to initialize Terraform:

```
terraform init
```
### 4: Apply the Terraform Configuration
Deploy the Helm Chart using Terraform by running:

```
terraform apply
```
Terraform will create the Helm Chart deployment in your Kubernetes cluster based on the provided configuration.

### 5: Access Your Deployed Application
After successful deployment, your application will be accessible within the specified namespace. Ensure to check the Helm Chart's documentation or README for any specific information on accessing your application.

### 6: Optional Cleanup
If needed, you can remove the deployed resources and clean up by running:

```
terraform destroy
```
Use this command when you no longer require the deployed resources.

Author
Brahim Bouallahui

## Annexe :
![image](https://github.com/caspa142/Delivrable-brahim/assets/118697002/a0d33ff1-2810-4775-b280-2170ae650d4e)
![image](https://github.com/caspa142/Delivrable-brahim/assets/118697002/6317819e-403e-487f-b815-2b2bcbd156f1)
![image](https://github.com/caspa142/Delivrable-brahim/assets/118697002/379f59d5-a06e-46ee-af46-3cc7d43027d6)
![image](https://github.com/caspa142/Delivrable-brahim/assets/118697002/4f7644e4-997e-4f5e-be57-baf078ece0c5)











