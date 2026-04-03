pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "arshitchoubey18/nodejs-app"
        TAG          = "${BUILD_NUMBER}"
        APP_NAME     = "nodejs-app"
    }

    stages {
        stage('Clone Code') {
            steps {
                checkout scm   // Better practice instead of hardcoded git clone
            }
        }

        stage('Install Dependencies & Test') {
            steps {
                sh 'npm ci'                    // Clean and fast install
                sh 'npm test --if-present'     // Runs tests if script exists, otherwise skips
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                usernameVariable: 'DOCKER_USER', 
                                passwordVariable: 'DOCKER_PASS')]) {
                    
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"   // Also push latest tag
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    # Use envsubst for clean templating
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
            cleanWs()                    // Clean workspace after build
        }
        success {
            echo '🎉 Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs.'
        }
    }
}
