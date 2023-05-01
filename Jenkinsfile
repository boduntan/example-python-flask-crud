pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'https://hub.docker.com/'
        DOCKER_USERNAME = credentials('thecodegirl')
        DOCKER_PASSWORD = credentials('Western4612%')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_USERNAME}", "${DOCKER_PASSWORD}") {
                        def app = docker.build('my-flask-app', '.')
                        app.push('latest')
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    sshagent(['flask_app']) {
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker pull docker://thecodegirl/my-flask-app:latest'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker stop my-flask-app || true'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker rm my-flask-app || true'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker run -d --name my-flask-app -p 80:5000 docker://thecodegirl/my-flask-app:latest'
                    }
                }
            }
        }
    }    
}