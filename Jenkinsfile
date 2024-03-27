pipeline {
    agent any
    environment {
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
        REGISTRY = 'asia.gcr.io/dakshay-goapptiv'
        STACK_NAME = 'myappstack'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                script {
                    sh "docker pull ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker stack deploy -c docker-compose.yml ${STACK_NAME}"
                }
            }
        }
    }
    post {
        always {
            echo 'Deployment process completed.'
        }
    }
}
