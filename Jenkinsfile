pipeline {
  agent any

  environment {
    IMAGE_NAME = "htmlproject:latest"
    CONTAINER_NAME = "htmlproject-container"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        bat 'dir'
      }
    }

    stage('Verify Docker') {
      steps {
        // Ensure docker is available on the agent. This will fail the build early if Docker is missing.
        bat '''
          echo ==== Docker version ====
          docker --version || (echo Docker not found & exit /b 1)
        '''
      }
    }

    stage('Build Docker Image (Maven runs inside Dockerfile)') {
      steps {
        bat '''
          echo ==== Building Docker image (this runs mvn inside the Maven stage) ====
          docker build -t %IMAGE_NAME% .
        '''
      }
    }

    stage('Stop & Remove Old Container') {
      steps {
        bat '''
          echo ==== Removing old container if exists ====
          powershell -Command "try { docker rm -f %CONTAINER_NAME% -ErrorAction SilentlyContinue } catch { }"
        '''
      }
    }

    stage('Run Tomcat Container') {
      steps {
        bat '''
          echo ==== Running new container ====
          docker run -d --name %CONTAINER_NAME% -p 8081:8080 %IMAGE_NAME%
          docker ps --filter "name=%CONTAINER_NAME%"
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful! Visit http://<jenkins-host-or-agent-ip>:8081"
    }
    failure {
      echo "❌ Pipeline failed. See console output for details."
    }
  }
}
