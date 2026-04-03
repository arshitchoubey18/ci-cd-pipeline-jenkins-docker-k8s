pipeline {
    agent any

    triggers {
        githubPush()   // ← Webhook trigger
    }

    environment {
        DOCKER_IMAGE = "arshitchoubey18/nodejs-app"
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

        stage('Install Dependencies & Run Tests') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build --no-cache -t $DOCKER_IMAGE:$TAG .'
            }
        }

                stage('Trivy Security Scan') {
            steps {
                script {
                    echo '🔍 Running Trivy Security Scan...'
                    // Use stable version instead of :latest + mount Docker socket
                    sh '''
                    docker run --rm \
                      -v /var/run/docker.sock:/var/run/docker.sock \
                      aquasec/trivy:0.69.3 image \
                        --exit-code 1 \
                        --no-progress \
                        --severity HIGH,CRITICAL \
                        ${DOCKER_IMAGE}:${TAG}
                    '''
                    echo '✅ Trivy Security Scan passed - No HIGH/CRITICAL vulnerabilities found'
                }
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
                sh 'kubectl rollout status deployment/nodejs-app --timeout=60s'
                sh 'kubectl get deployment nodejs-app -o=jsonpath="{.spec.template.spec.containers[0].image}"'
                echo '✅ Deployment verified successfully'
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
