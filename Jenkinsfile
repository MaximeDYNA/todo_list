pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout code from the repository
                git branch: 'main', 
                    url: 'https://github.com/MaximeDYNA/todo_list.git'
            }
        }

        stage('Python Environment') {
            steps {
                // Set up Python environment
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt'''
            }
        }

         stage('Run Django Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    python manage.py test
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Tests failed. Pipeline stopped.'
        }
        success {
            echo '✅ Tests passed. CI is healthy.'
        }
    }
}