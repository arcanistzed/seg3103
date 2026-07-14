pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
            publishChecks name: 'Jenkins CI', title: 'Jenkins CI', summary: 'All tests passed', status: 'COMPLETED', conclusion: 'SUCCESS'
        }
        failure {
            publishChecks name: 'Jenkins CI', title: 'Jenkins CI', summary: 'One or more tests failed', status: 'COMPLETED', conclusion: 'FAILURE'
        }
        always {
            archiveArtifacts artifacts: 'python-backend/coverage.xml', allowEmptyArchive: true
            archiveArtifacts artifacts: 'js-backend/coverage/**', allowEmptyArchive: true
        }
    }
}
