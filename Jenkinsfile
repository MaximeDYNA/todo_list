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

        stage('Django Check') {
            steps {
                // Run Django checks
                sh '''
                . venv/bin/activate
                python manage.py check'''
            }
        }
    }
}