pipeline {
    agent { dockerfile true }
    environment {
        PATH = "/usr/local/bin:$PATH"
        HOME = "/var/lib/jenkins"
    }
    stages {
        stage('setup') {
            steps {
                sh "env"
                sh "pwd"
                sh "ls -la"
                sh "HOME=. npm install"
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
    }
}