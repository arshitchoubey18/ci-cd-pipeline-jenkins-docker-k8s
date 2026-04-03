pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "arshitchoubey18/nodejs-app"
        TAG          = "${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test --if-present'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${TAG} ."
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                sh '''
                    echo "Running Trivy vulnerability scan..."
                    trivy image --exit-code 1 \
                                --severity HIGH,CRITICAL \
                                --format table \
                                ${DOCKER_IMAGE}:${TAG}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                usernameVariable: 'DOCKER_USER', 
                                passwordVariable: 'DOCKER_PASS')]) {
                    
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    IMAGE_TAG=${TAG} envsubst < k8s/deployment.yaml > k8s/deployment-rendered.yaml
                    kubectl apply -f k8s/deployment-rendered.yaml
                    kubectl apply -f k8s/service.yaml
                    echo "Deployment completed with image tag: ${TAG}"
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
            cleanWs()
        }
        success {
            echo '🎉 Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
