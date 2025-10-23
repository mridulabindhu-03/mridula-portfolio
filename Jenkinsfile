pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // Use the same repo & credentials already wired to the job
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        bat '''
          echo ==== Docker version ====
          docker --version || echo Docker not found
          echo ==== Build image ====
          docker build -t htmlproject:latest .
        '''
      }
    }

    stage('Stop & Remove Old Container') {
      steps {
        // Use PowerShell to remove the container if it exists (silently ignore errors)
        bat '''
          echo ==== Removing old container (if any) ====
          powershell -Command "try { docker rm -f htmlproject-container -ErrorAction SilentlyContinue } catch { }"
        '''
      }
    }

    stage('Run Tomcat Container') {
      steps {
        bat '''
          echo ==== Starting new container ====
          docker run -d --name htmlproject-container -p 8081:8080 htmlproject:latest
          echo ==== List running containers ====
          docker ps --filter "name=htmlproject-container"
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful! Visit http://<your-jenkins-host>:8081"
    }
    failure {
      echo "❌ Pipeline failed. Check the console output for errors."
    }
  }
}
