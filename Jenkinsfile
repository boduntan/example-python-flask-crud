pipeline {
    agent any
    tools {
        git 'Default'
    }
    environment {
        SSH_CRED = credentials('flask-app')
        def CONNECT = 'ssh -o StrictHostKeyChecking=no ubuntu@ec2-35-183-27-121.ca-central-1.compute.amazonaws.com'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/thecodegirl/py_flask', 'dockerhub') {
                        def app = docker.build('my-flask-app', '.')
                        app.push('latest')
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    sshagent(['flask-app']) {
                        sh 'ssh ubuntu@ec2-35-183-27-121.ca-central-1.compute.amazonaws.com docker pull https://hub.docker.com/repository/docker/thecodegirl/my-flask-app:latest'
                        sh 'ssh ubuntu@ec2-35-183-27-121.ca-central-1.compute.amazonaws.com docker stop my-flask-app || true'
                        sh 'ubuntu@ec2-35-183-27-121.ca-central-1.compute.amazonaws.com docker rm my-flask-app || true'
                        sh 'ubuntu@ec2-35-183-27-121.ca-central-1.compute.amazonaws.com docker run -d --name my-flask-app -p 80:5000 https://hub.docker.com/repository/docker/thecodegirl//my-flask-app:latest'
                    }
                }
            }
        }
    }
}