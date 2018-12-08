pipeline {
  agent any

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  stages {

    stage('Deploy') {
      when {
        expression {env.BRANCH_NAME == 'master'}
      }

      steps {
        sh 'docker stack deploy --compose-file docker-compose.yml elk-stack'
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