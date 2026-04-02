pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/nodejs-app"
        TAG = "${BUILD_NUMBER}"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:$TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                cp k8s/deployment.yaml k8s/deployment-final.yaml
                sed -i "s|IMAGE_TAG|$TAG|g" k8s/deployment-final.yaml
                kubectl apply -f k8s/deployment-final.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl rollout status deployment/nodejs-app'
                sh 'kubectl get pods'
                sh 'kubectl get svc'
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
