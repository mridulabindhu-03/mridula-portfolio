pipeline {
  agent any

  tools {
    // Name must match a Maven install configured in Manage Jenkins -> Global Tool Configuration
    maven 'Maven'       
    jdk 'JDK'           // optional: name of installed JDK in Jenkins
  }

  stages {
    stage('Prepare') {
      steps {
        echo "Running on: ${env.NODE_NAME}"
        echo "Workspace: ${env.WORKSPACE}"
        bat 'dir'
      }
    }

    stage('Maven - Build') {
      steps {
        // If mvn is on PATH on agent this will work. If not, configure Maven tool and use mvn.
        bat 'mvn -v'
        bat 'mvn -B -DskipTests=false clean package'
      }
    }

    stage('Archive') {
      steps {
        // adjust the artifact pattern if different
        archiveArtifacts artifacts: 'target/**/*.jar', fingerprint: true
      }
    }
  }

  post {
    success { echo "Pipeline finished SUCCESS" }
    failure { echo "Pipeline finished FAILURE"; bat 'dir target || echo no target dir' }
  }
}
