pipeline {
    agent any
    environment {
        IMAGE_NAME = 'my-app'
        NEW_TAG = "1.0.${BUILD_NUMBER}"
        REGISTRY = 'asia.gcr.io/dakshay-goapptiv'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Global GCP Authentication') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud auth configure-docker'
                    }
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${NEW_TAG} ."
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:${NEW_TAG}"
                }
            }
        }
        stage('Deploy New Version') {
            steps {
                script {
                    // Update docker-compose.yml with the new image tag
                    sh "sed -i 's|image: ${REGISTRY}/${IMAGE_NAME}:.*|image: ${REGISTRY}/${IMAGE_NAME}:${NEW_TAG}|' docker-compose.yml"

                    // Deploy the new version alongside the old one
                    sh "docker compose up -d --no-deps --build webapp"
                    sh "docker compose scale webapp=2"
                }
            }
        }
        stage('Health Check and Switch Traffic') {
            steps {
                script {
                    sh "sleep 20"
                }
            }
        }
        stage('Scale Down Old Version') {
            steps {
                script {
                    sh "docker compose scale webapp=1"
                }
            }
        }
    }
    post {
        always {
            echo 'Deployment process completed'
        }
    }
}