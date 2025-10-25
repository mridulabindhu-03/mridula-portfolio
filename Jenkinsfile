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
      echo ==== Check for existing container and remove if present ====
      powershell -Command "$c = (docker ps -a --filter \\"name=%CONTAINER_NAME%\\" --format \\"{{.Names}}\\"); if ($c) { Write-Output (\\"Found container: $c\\"); docker rm -f %CONTAINER_NAME%; Write-Output \\"Removed container.\\" } else { Write-Output \\"No container to remove.\\" }"
    '''
  }
}


   stage('Run Tomcat Container') {
      steps {
        bat '''
          echo ==== Starting Tomcat container ====
          docker run -d --name %CONTAINER_NAME% -p 8081:8080 %IMAGE_NAME%
          echo ==== Active Containers ====
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
