# ✅ CI/CD Pipeline Project Checklist

This checklist ensures that the CI/CD pipeline project is fully functional, production-ready (lab-level), and properly structured for demonstration and interviews.

---

## 📌 1. Repository Setup

* [ ] Repository name is `ci-cd-pipeline-jenkins-docker-k8s`
* [ ] Repository is public
* [ ] Proper description added
* [ ] README.md is complete and well-structured

---

## 📁 2. Project Structure

* [ ] app.js exists
* [ ] package.json exists
* [ ] Dockerfile exists
* [ ] Jenkinsfile exists
* [ ] README.md exists

### Kubernetes Files

* [ ] k8s/deployment.yaml exists
* [ ] k8s/service.yaml exists

### Screenshots Folder

* [ ] screenshots/ folder created
* [ ] Jenkins pipeline screenshot added
* [ ] Kubernetes pods screenshot added
* [ ] Service screenshot added
* [ ] Application output screenshot added

---

## ⚙️ 3. Application Verification

* [ ] Application runs locally
* [ ] `/` endpoint working
* [ ] `/health` endpoint working

Test commands:

```bash
npm install
npm start
curl http://localhost:3000
curl http://localhost:3000/health
```

---

## 🐳 4. Docker Verification

* [ ] Docker image builds successfully
* [ ] Container runs without error
* [ ] Application accessible via Docker

Commands:

```bash
docker build -t nodejs-app:test .
docker run -d -p 3000:3000 nodejs-app:test
docker ps
```

---

## ☸️ 5. Kubernetes Verification

* [ ] Deployment created successfully
* [ ] Pods are in Running state
* [ ] Service is created
* [ ] Application accessible via NodePort / Minikube

Commands:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods
kubectl get svc
```

---

## 🔁 6. Rolling Update Verification

* [ ] Multiple replicas configured (2 or 3)
* [ ] Rolling update strategy enabled
* [ ] No downtime during deployment
* [ ] Pods update gradually

Commands:

```bash
kubectl rollout status deployment/nodejs-app
kubectl get pods -w
```

---

## 🔥 7. Jenkins CI/CD Verification

* [ ] Jenkins pipeline runs successfully
* [ ] Code is cloned from GitHub
* [ ] Docker image is built
* [ ] Docker image is pushed to Docker Hub
* [ ] Kubernetes deployment is updated

---

## 📦 8. Docker Hub Verification

* [ ] Image pushed successfully
* [ ] Image tag matches Jenkins build number
* [ ] Repository accessible

Example:

```bash
arshitchoubey18/nodejs-app:<tag>
```

---

## 🔍 9. End-to-End Test

* [ ] Code change pushed to GitHub
* [ ] Jenkins pipeline triggered
* [ ] New Docker image built
* [ ] Kubernetes deployment updated
* [ ] Application reflects latest changes

---

## ⚠️ 10. Common Issues Checked

* [ ] Docker permission issues resolved
* [ ] ImagePull errors resolved
* [ ] kubeconfig permissions correct
* [ ] Service accessible from browser

---

## 🚀 Final Status

* [ ] CI/CD pipeline working end-to-end
* [ ] Application deployed successfully
* [ ] Zero/minimal downtime achieved
* [ ] Project ready for resume and interviews

---

## 👨‍💻 Author

Arshit Choubey
DevOps Learner | Technical Support Engineer
