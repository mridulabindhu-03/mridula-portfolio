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

    stage('Verify Maven (optional)') {
      steps {
        echo "Checking local mvn/java availability on agent"
        bat 'where mvn || echo mvn not found'
        bat 'where java || echo java not found'
        // Optional: run a local package to verify (comment out if Docker build handles mvn)
        // bat 'mvn -B -DskipTests=true clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat '''
          echo ==== Docker version ====
          docker --version || (echo Docker not found & exit /b 1)
          echo ==== Building Docker image ====
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
