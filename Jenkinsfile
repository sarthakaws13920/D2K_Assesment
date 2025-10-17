pipeline {
    agent any

    parameters {
        choice(
            name: 'DEPLOY_ENV', 
            choices: ['UAT', 'PROD'], 
            description: 'Select environment to deploy'
        )
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-credentials')
        SSH_KEY = credentials('app-ec2')
        IMAGE_NAME = "sarthak13920/dotnet-api"
        TARGET_IP = "172.31.27.254"
    }

    stages {

        // Stage 1: Checkout code from GitHub
        stage('Checkout') {
            steps {
                git 'https://github.com/sarthakaws13920/D2K_Assesment.git'
            }
        }

        // Stage 2: Build Docker image
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        // Stage 3: Push Docker image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-credentials', 
                        usernameVariable: 'USER', 
                        passwordVariable: 'PASS'
                    )
                ]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker push $IMAGE_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }

        // Stage 4: Deploy Docker image to EC2
        stage('Deploy to EC2') {
            steps {
                sshagent(['app-ec2']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@$TARGET_IP '
                        docker pull $IMAGE_NAME:$BUILD_NUMBER &&
                        docker stop dotnet-api || true &&
                        docker rm dotnet-api || true &&
                        docker run -d -p 80:80 --name dotnet-api $IMAGE_NAME:$BUILD_NUMBER
                    '
                    """
                }
            }
        }
    }
}
