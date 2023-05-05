pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = 'flask_app'
        SSH_CRED = credentials('new_pair')
        SSH_HOST = 'ec2-3-98-120-44.ca-central-1.compute.amazonaws.com'
        SSH_USER = 'ubuntu'
        DOCKER_IMAGE_NAME = 'py_flask'
        DOCKER_IMAGE_TAG = 'latest'
    }
    stages {
        stage('Build and Push Image') {
            steps {
                script {
                    // Build the Docker image
                    
                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        //def image = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")
                        sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                        //docker.image("thecodegirl/my-flask-app").push("latest")
                        sh """
                
                            docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -f Dockerfile .
                            docker tag py_flask thecodegirl/py_flask:latest
                            docker push thecodegirl/py_flask:latest
                            """
                        //docker.image("${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
                        //dockerImage.push("${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")


                    }
                }
            }
        }


        stage('Deploy Docker Image') {
            steps {
                script {
                    sshagent([SSH_CRED]) {
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} docker pull thecodegirl/py_flask:latest"
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} docker stop my-flask-app || true"
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} docker rm my-flask-app || true"
                    sh "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} docker run -d --name my-flask-app -p 80:5000 ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }    
}

