pipeline {
  agent any

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  stages {

    stage('Deploy Stack') {
      when {
        expression {env.BRANCH_NAME == 'master'}
      }

      steps {
        sh 'docker stack deploy --compose-file docker-compose.yml elk-stack'
        sleep 30
      }
    }

    stage('Deploy Pipelines') {
      when {
        expression {env.BRANCH_NAME == 'master'}
      }

      steps {
        sh 'chmod +x setup-pipelines.sh'
        sh './setup-pipelines.sh'
      }
    }
  }

  post {
    always {
      sh 'docker system prune --force || true'
    }

    failure {
      emailext body: 'Build log can be found at $BUILD_URL', recipientProviders: [brokenBuildSuspects()], subject: '$JOB_NAME Failed to Deploy', to: 'paul.trampert@ptrampert.com'
    }
  }
}