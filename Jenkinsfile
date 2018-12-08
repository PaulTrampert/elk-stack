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
}