pipeline {
    agent any

    environment {
        // Define any environment variables here
        DOCKER_IMAGE = "maximedyna/todo-django"
        DOCKER_TAG   = "latest"
        CONTAINER_NAME = "todo-django"

    }

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout code from the repository
                echo '📥 Checking out source code...'
                git branch: 'main', 
                    url: 'https://github.com/MaximeDYNA/todo_list.git'
            }
        }

        /*stage('Python Environment') {
            steps {
                // Set up Python environment
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt'''
            }
        }*/

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

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                '''
            }
        }

       stage('Stop Old Container') {
            steps {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }


        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                docker push $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }

         stage('Deploy Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true

                docker run -d \
                  --name $CONTAINER_NAME \
                  --restart unless-stopped \
                  -p 8005:8000 \
                  $DOCKER_IMAGE:$DOCKER_TAG
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