pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-credentials') // Add your Docker Hub credentials in Jenkins
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
                    docker.build("sarthak13920/dotnet-api:latest")
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
            sh """
                ssh -o StrictHostKeyChecking=no ec2-user@172.31.27.254 \\
                'docker pull sarthak13920/dotnet-api:latest && \\
                 docker stop dotnet-api || true && \\
                 docker rm dotnet-api || true && \\
                 docker run -d --name dotnet-api -p 5000:80 sarthak13920/dotnet-api:latest'
            """
        }
    }
   }
    }
}
