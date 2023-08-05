pipeline {
    agent any 
    environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-password')
    }
    stages { 

        stage('Build docker image') {
            steps {  
                sh 'docker build -t sequencexyz/flaskapp:1 .'
            }
        }
        stage('login to dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('push image') {
            steps{
                sh 'docker push sequencexyz/flaskapp:1'
            }
        }
}
post {
        always {
            sh 'docker logout'
        }
    }
}
