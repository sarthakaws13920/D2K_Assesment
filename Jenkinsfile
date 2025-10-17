pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') // Add your Docker Hub credentials in Jenkins
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
                    docker.build("sarthak13920/dotnet-api:latest")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKERHUB_CREDENTIALS') {
                        docker.image("sarthak13920/dotnet-api:latest").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key-id']) { // Add your EC2 SSH key in Jenkins credentials
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@<EC2_PUBLIC_IP> \\
                        'docker pull sarthak13920/dotnet-api:latest && docker stop dotnet-api || true && docker rm dotnet-api || true && docker run -d --name dotnet-api -p 5000:80 sarthak13920/dotnet-api:latest'
                    """
                }
            }
        }
    }
}
