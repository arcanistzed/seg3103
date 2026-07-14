pipeline {
    agent any

    stages {
        stage('Environment') {
            steps {
                sh '''
                    python3 --version
                    node --version
                    npm --version
                '''
            }
        }

        stage('Automated Tests') {
            parallel {
                stage('Python Tests') {
                    steps {
                        sh './scripts/test-python.sh'
                    }
                }

                stage('JavaScript Tests') {
                    steps {
                        sh './scripts/test-javascript.sh'
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                try {
                    publishChecks name: 'Jenkins CI', title: 'Jenkins CI',
                        summary: 'All tests passed',
                        status: 'COMPLETED', conclusion: 'SUCCESS'
                } catch (Exception error) {
                    echo "Unable to publish GitHub check: ${error.message}"
                }
            }
        }
        failure {
            script {
                try {
                    publishChecks name: 'Jenkins CI', title: 'Jenkins CI',
                        summary: 'One or more tests failed',
                        status: 'COMPLETED', conclusion: 'FAILURE'
                } catch (Exception error) {
                    echo "Unable to publish GitHub check: ${error.message}"
                }
            }
        }
        always {
            archiveArtifacts artifacts: 'python-backend/coverage.xml',
                allowEmptyArchive: true
            archiveArtifacts artifacts: 'js-backend/coverage/**',
                allowEmptyArchive: true
        }
    }
}
