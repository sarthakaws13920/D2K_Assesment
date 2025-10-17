pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-credentials')  // Docker Hub creds ID in Jenkins
        EC2_PRIVATE_IP = "172.31.27.254"                           // App EC2 private IP
        IMAGE_NAME = "sarthak13920/dotnet-api"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sarthakaws13920/D2K_Assesment.git', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build using correct folder context
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}", "./hello-world-api")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push("latest")
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key-id']) {   // Make sure this matches your Jenkins credential ID
                    sh """
                        set -e
                        ssh -o StrictHostKeyChecking=no ec2-user@$EC2_PRIVATE_IP '
                            docker pull ${IMAGE_NAME}:latest &&
                            docker stop dotnet-api || true &&
                            docker rm dotnet-api || true &&
                            docker run -d --name dotnet-api -p 80:80 ${IMAGE_NAME}:latest
                        '
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                sshagent(['ec2-ssh-key-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@$EC2_PRIVATE_IP '
                            curl -f http://localhost:80 || exit 1
                        '
                    """
                }
            }
        }
    }
}
