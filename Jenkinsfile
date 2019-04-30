node()
{
    stage('Checkout')
    {
        // Git check out the sample java application repository
        git changelog: false, credentialsId: 'Github', poll: false, url: 'https://github.com/venkatalolla/sample-java.git'
    }

    stage('Build')
    {
        // Build the application using Maven
        withMaven(maven: 'maven') 
        {
            sh "mvn clean install"
        }
    }

    stage('Build Docker Image')
    {
        // Build the Dockerfile
        sh "docker build -t java-app:latest"        
    }

    stage('Create Helm Chart')
    {
        // Create a Helm Chart
    }
}