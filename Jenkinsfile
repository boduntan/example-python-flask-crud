pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'new_pair'
        DOCKER_IMAGE_NAME = 'py_flask'
        DOCKER_IMAGE_TAG = 'latest'
    }

    stages {
        stage('Build and Push Image') {
            steps {
                script {
                    // Build the Docker image
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")

                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        dockerImage.push("${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                    }
                }
            }
        }

        stage('Pull and Build Image') {
            steps {
                script {
                    // Authenticate with Docker Hub
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        // Pull the Docker image
                        docker.image("${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").pull()

                        // Build using the pulled Docker image
                        def container = docker.container("${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").withRun('--rm', '-d')
                        try {
                            container.waitForCondition(timeout: 120, condition: { container.logContains('Build completed successfully') })
                        } finally {
                            container.stop()
                        }
                    }
                }
            }
        }
    }
}
