````md
# CI/CD Pipeline with Jenkins, Docker, and Kubernetes 🚀

## 📌 Project Overview

This project demonstrates a complete **CI/CD pipeline** for deploying a Node.js application using **Jenkins, Docker, and Kubernetes**.

The pipeline automates the entire workflow from code commit to deployment, ensuring faster delivery, consistency, and minimal downtime.

---

## 🧠 What This Project Does

- Pulls source code from GitHub
- Builds Docker image for Node.js app
- Pushes image to Docker Hub
- Deploys application to Kubernetes
- Performs rolling updates (zero/minimal downtime)
- Uses health checks (readiness probe)

---

## 🏷️ Title

**CI/CD Pipeline (Jenkins, Docker, Kubernetes)**

---

## 🚀 Key Features

- End-to-end CI/CD automation using Jenkins
- Dockerized Node.js application
- Kubernetes deployment with multiple replicas
- Rolling update strategy for zero downtime
- Readiness probe for health checks
- Dynamic Docker image tagging using Jenkins build number

---

## 🏗️ Architecture

```text
Developer → GitHub → Jenkins → Docker Build → Docker Hub → Kubernetes → Application
````

---

## 🛠️ Tech Stack

| Category         | Tools Used                    |
| ---------------- | ----------------------------- |
| Application      | Node.js, Express.js           |
| CI/CD            | Jenkins                       |
| Containerization | Docker                        |
| Registry         | Docker Hub                    |
| Orchestration    | Kubernetes                    |
| Version Control  | Git, GitHub                   |
| Environment      | Local VM / Minikube / AWS EC2 |

---

## 📁 Project Structure

```bash
ci-cd-pipeline-jenkins-docker-k8s/
│
├── app.js
├── package.json
├── package-lock.json
├── Dockerfile
├── Jenkinsfile
├── README.md
└── k8s/
    ├── deployment.yaml
    └── service.yaml
```

---

## 🌐 Application Endpoints

| Endpoint  | Description                 |
| --------- | --------------------------- |
| `/`       | Main application route      |
| `/health` | Health check for Kubernetes |

---

## 🔄 CI/CD Workflow

1. Developer pushes code to GitHub
2. Jenkins pipeline is triggered
3. Jenkins pulls code from GitHub
4. Docker image is built
5. Image is pushed to Docker Hub
6. Kubernetes deployment is updated
7. Rolling update is performed

---

## ⚙️ Jenkins Pipeline Stages

* Clone Code
* Build Docker Image
* Push Docker Image
* Deploy to Kubernetes

---

## 📄 Jenkinsfile

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "arshitchoubey18/nodejs-app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/arshitchoubey18/ci-cd-pipeline-jenkins-docker-k8s.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:$TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'sed -i "s|IMAGE_TAG|$TAG|g" k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}
```

---

## 🐳 Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

---

## ☸️ Kubernetes Deployment

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: arshitchoubey18/nodejs-app:IMAGE_TAG
        ports:
        - containerPort: 3000
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 10
```

---

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodejs-service
spec:
  selector:
    app: nodejs-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: NodePort
```

---

## ▶️ How to Run This Project

### 1. Clone Repository

```bash
git clone https://github.com/arshitchoubey18/ci-cd-pipeline-jenkins-docker-k8s.git
cd ci-cd-pipeline-jenkins-docker-k8s
```

---

### 2. Run App Locally

```bash
npm install
npm start
```

---

### 3. Build Docker Image

```bash
docker build -t nodejs-app:v1 .
docker run -d -p 3000:3000 nodejs-app:v1
```

---

### 4. Deploy to Kubernetes

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

---

## 🔁 Rolling Update Strategy

This project uses:

* Multiple replicas (3 pods)
* Rolling update deployment
* Readiness probe

### Result:

* No downtime during deployment
* Traffic only routed to healthy pods

---

## 🧪 Verification Commands

```bash
kubectl get pods
kubectl get svc
kubectl describe deployment nodejs-app
kubectl rollout status deployment/nodejs-app
```

---

## 📸 Screenshots 

This folder contains project screenshots.

## Jenkins Pipeline Execution (Stage View)

This screenshot shows the successful execution of the CI/CD pipeline, including code checkout, Docker image build, push to Docker Hub, and Kubernetes deployment.

<img width="1354" height="603" alt="image" src="https://github.com/user-attachments/assets/040eb095-9fe0-40ca-b3ff-e5e9e6c063a8" />

## Kubernetes Pods Status

The following screenshot shows the running pods after deployment. All replicas are in Running state with zero restarts, confirming a successful and stable deployment.

<img width="1355" height="212" alt="image" src="https://github.com/user-attachments/assets/b53c2d52-2910-4dda-b180-b8094629150a" />

## Kubernetes Service (NodePort)

The following screenshot shows the Kubernetes service exposing the application using NodePort. The application is accessible externally via the assigned NodePort.

<img width="1355" height="212" alt="image" src="https://github.com/user-attachments/assets/8e49a218-4f72-4231-9e20-738724e10cfc" />

## Application Running (Live Proof)

The application is successfully deployed on Kubernetes and accessible via NodePort. The screenshot below confirms the live application output after CI/CD pipeline execution.

<img width="1355" height="212" alt="image" src="https://github.com/user-attachments/assets/2a087b16-8127-4bbe-a035-8ba69fd0e3ed" />
<img width="1355" height="212" alt="image" src="https://github.com/user-attachments/assets/dbbe1d25-166a-41ce-b0b6-749c18d3009f" />


---

## ⚠️ Challenges Faced

* Docker permission issues in Jenkins
* Image tag mismatch
* Kubernetes ImagePull errors
* kubeconfig permission issues
* Service accessibility problems

---

## 🔮 Future Improvements

* Add Helm deployment
* Add GitHub webhook trigger
* Add Prometheus & Grafana monitoring
* Add Ingress controller
* Add rollback strategy

---

## 💼 Highlights

* Built CI/CD pipeline using Jenkins, Docker, Kubernetes
* Automated deployment process end-to-end
* Implemented rolling updates and health checks
* Reduced manual effort using pipeline automation

---

## 👨‍💻 Author

**Arshit Choubey**
Technical Support Engineer | DevOps Enthusiast

GitHub: [https://github.com/arshitchoubey18](https://github.com/arshitchoubey18)
LinkedIn: [https://linkedin.com/in/arshitchoubey](https://linkedin.com/in/arshitchoubey)

