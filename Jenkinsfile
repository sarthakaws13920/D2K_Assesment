pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-credentials') // Docker Hub credentials ID in Jenkins
        EC2_PRIVATE_IP = "172.31.27.254"
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
                    docker.build("arthak13920/dotnet-api:latest", "hello-world-api")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        docker.image("sarthak13920/dotnet-api:latest").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key-id']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@172.31.27.254 "
                            set -e
                            echo 'Stopping old container (if exists)...'
                            docker stop dotnet-api || true
                            docker rm dotnet-api || true

                            echo 'Pulling latest image from Docker Hub...'
                            docker pull sarthak13920/dotnet-api:latest

                            echo 'Starting new container...'
                            docker run -d --name dotnet-api -p 80:80 sarthak13920/dotnet-api:latest

                            echo 'Container deployed successfully.'
                        "
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                sshagent(['ec2-ssh-key-id']) {
                    sh '''
                        echo "Performing health check on deployed application..."
                        ssh -o StrictHostKeyChecking=no ec2-user@172.31.27.254 "
                            curl -f http://localhost:80/api/hello || exit 1
                        "
                        echo "Health check passed: Application is running successfully!"
                    '''
                }
            }
        }
    }
}
