pipeline {
  agent any;

  environment {
    UPSTREAM_NAME = 'ldap-user-manager'
    CONTAINER_NAME = 'tkf-docker-lum'

    LUM_VERSION="v1.7"
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    //pipelineTriggers([cron('H 0 * * 0')])
  }
  
   stages {
    stage('Setup Environment') {
      steps {
        script {
          env.EXIT_STATUS = ''
          env.CURR_DATE = sh(
            script: '''date '+%Y-%m-%d_%H:%M:%S%:z' ''',
            returnStdout: true).trim()
          env.GITHASH_SHORT = sh(
            script: '''git log -1 --format=%h''',
            returnStdout: true).trim()
          env.GITHASH_LONG = sh(
            script: '''git log -1 --format=%H''',
            returnStdout: true).trim()
        }
      }
    }
    stage('Buildx') {
      agent {
        label 'x86_64'
      }

      steps {
        echo "Running on node: ${NODE_NAME}"
        deleteDir()
        //git([url: 'https://github.com/teknofile/ldap-user-manager.git', branch: env.BRANCH_NAME, credentialsId: 'TKFBuildBot'])
        git([url: env.GIT_URL, branch: env.BRANCH_NAME, credentialsId: 'TKFBuildBot'])
        withDockerRegistry(credentialsId: 'teknofile-dockerhub', url: "https://index.docker.io/v1/") {
          sh '''
            docker buildx create --name tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT} --use
            docker buildx inspect tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT} --bootstrap

            docker buildx build \
              --no-cache \
              --pull \
              --builder tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT} \
              --platform linux/arm64,linux/amd64 \
              --build-arg LUM_VERSION=${LUM_VERSION} \
              -t teknofile/${CONTAINER_NAME} \
              -t teknofile/${CONTAINER_NAME}:latest \
              -t teknofile/${CONTAINER_NAME}:${GITHASH_LONG} \
              -t teknofile/${CONTAINER_NAME}:${GITHASH_SHORT} \
              -t teknofile/${CONTAINER_NAME}:${LUM_VERSION} \
              . \
              --push

            docker buildx stop tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT}
            docker buildx rm tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT}
          '''
        }
      }
    }
  }
  post {
    always {
      echo 'Cleaning up.'
      deleteDir() /* clean up our workspace */
    }
  }
}