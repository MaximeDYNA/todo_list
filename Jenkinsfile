pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout code from the repository
                echo '📥 Checking out source code...'
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

         stage('Run Django Tests') {
            steps {
                // Run Django tests
                echo '🧪 Running tests...'
                sh '''
                    . venv/bin/activate
                    python manage.py test
                '''
            }
        }
    }

   post {
        always {
            echo '🔔 Sending notification to Discord...'

            script {
                def payload = """{
                    "username": "Jenkins CI",
                    "content": "📦 **Pipeline Finished**\\n\
                    🔧 Job: ${env.JOB_NAME}\\n\
                    🔢 Build: #${env.BUILD_NUMBER}\\n\
                    📊 Status: ${currentBuild.currentResult}\\n\
                    🔗 ${env.BUILD_URL}"
                }"""

                withCredentials([
                    string(
                        credentialsId: 'DISCORD_WEBHOOK_URL',
                        variable: 'DISCORD_WEBHOOK'
                    )
                ]) {
                    sh """
                        curl -s -H 'Content-Type: application/json' \
                             -X POST \
                             -d '${payload}' \
                             "\$DISCORD_WEBHOOK"
                    """
                }
            }
       }    
    
    }
}