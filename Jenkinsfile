pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'docker.io'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                script {
                    withCredentials([[
                        $class: 'UsernamePasswordMultiBinding',
                        credentialsId: 'Dockerhub',
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
                    sshagent(['flask_app']) {
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker pull thecodegirl/my-flask-app:latest'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker stop my-flask-app || true'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker rm my-flask-app || true'
                        sh 'ssh ubuntu@ec2-15-222-253-202.ca-central-1.compute.amazonaws.com docker run -d --name my-flask-app -p 80:5000 thecodegirl/my-flask-app:latest'
                    }
                }
            }
        }
    }    
}
