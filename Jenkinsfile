pipeline {
    agent any
    environment {
        SSH_CRED = credentials('flask_app')
        SSH_HOST = 'ec2-3-96-160-14.ca-central-1.compute.amazonaws.com'
        SSH_USER = 'ubuntu'
        DOCKER_REGISTRY = 'docker.io'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                script {
                    withCredentials([[
                        $class: 'UsernamePasswordMultiBinding',
                        credentialsId: 'new_pair',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                     ]]) {
                        docker.withRegistry('${DOCKER_REGISTRY}', '${DOCKER_USERNAME}', '${DOCKER_PASSWORD}') {
                            def image = docker.build("thecodegirl/my-flask-app", "--file Dockerfile .")
                            docker.image(image.id).inside {
                                sh "pip install --upgrade pip"
                                sh "export FLASK_APP=crudapp.py"
                                sh "flask db init"
                                sh 'flask db migrate -m "entries table"'
                                sh "flask db upgrade"
                                sh "flask run --host=0.0.0.0"
                            }
                            docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_USERNAME}", "${DOCKER_PASSWORD}") {
                                docker.image("thecodegirl/my-flask-app").push("latest")
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    sshagent([SSH_CRED]) {
                        sh "ssh ${SSH_USER}@${SSH_HOST} docker pull thecodegirl/my-flask-app:latest"
                        sh "ssh ${SSH_USER}@${SSH_HOST} docker stop my-flask-app || true"
                        sh "ssh ${SSH_USER}@${SSH_HOST} docker rm my-flask-app || true"
                        sh "ssh ${SSH_USER}@${SSH_HOST} docker run -d --name my-flask-app -p 80:5000 thecodegirl/my-flask-app:latest"
                    }
                }
            }
        }
    }    
}

