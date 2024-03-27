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
        
        stage('Write .env File') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'env-file', variable: 'ENV_FILE')]) {
                        writeFile file: '.env', text: readFile(ENV_FILE)
                    }
                }
            }
        }


        stage('Build and Push Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME} ."
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}"
                }
            }
        }

        stage('Update Service') {
            steps {
                script {
                    sh "docker compose pull"
                    sh "docker compose up -d"
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