pipeline {
    agent { label 'build' } // Нода, де є Go
    environment {
        REPO_URL = 'https://github.com/Tymchuk25/gogsprod.git'
        GH_TOKEN = credentials('github-token')
        ZIP_NAME = 'gogs.zip'
        DOCKER_IMAGE = 'ghcr.io/tymchuk25/gogs'
        DOCKER_LINT_TAG = "${DOCKER_IMAGE}:lint"
        DOCKER_TEST_TAG = "${DOCKER_IMAGE}:test"
        DOCKER_LATEST = "${DOCKER_IMAGE}:latest"
    }
    stages {
        stage('Lint Check'){
            steps{
                echo 'Lintting...'
                sh 'docker build -t ${DOCKER_LINT_TAG} --target lint .'    
            }
        }

        stage('Test Application'){
            steps {
                echo 'Running tests...'  
                sh 'docker build -t ${DOCKER_TEST_TAG} --target test .'        
            }
        }
        
        stage('Build Artifact') {
            when { branch 'main' }
            steps {
                echo 'Building the application...'
                sh 'docker build -t ${DOCKER_LATEST} .'
            }
        }

        stage('Docker login') {
            steps {
                echo 'Logging in to Docker Hub'
                script {
                    withCredentials([usernamePassword(credentialsId: 'ghcr-token', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'echo $PASSWORD | docker login ghcr.io -u $USERNAME --password-stdin'
                    }
                }
            }
        } 

        stage('Docker Push'){
            steps{
                echo 'Pushing Docker image to ghcr.io'
                sh "docker push ${DOCKER_LATEST}"
            }
        }
    } 

    post {         
        always {
            cleanWs()
            sh 'docker logout'
            sh 'docker system prune -fa'
        }
    }
} 
