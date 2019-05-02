node()
{
    stage('Checkout')
    {
        // Git check out the sample java application repository
        git changelog: false, credentialsId: 'Github', poll: false, url: 'https://github.com/venkatalolla/sample-java.git'
    }

    //cleanWs()
    // Global version variable concatinating from VERSION file
    version = sh (script: "cat ${WORKSPACE}/VERSION", returnStdout: true)

    stage('Build')
    {
        // Build the application using Maven
        withMaven(maven: 'maven') 
        {
            sh "mvn clean install -Drelease.version=${version}.${env.BUILD_NUMBER}"
        }
    }

    stage('Build Docker Image')
    {
        // Build the Dockerfile
        sh "docker build . -t suryalolla/java-app:${version}.${env.BUILD_NUMBER}"        
    }

    stage('Docker Push')
    {
        // Push the docker image to docker hub
        sh "docker push suryalolla/java-app:${version}.${env.BUILD_NUMBER}"
    }
    stage('Create Helm Chart')
    {
        //  sh "helm package"
    }
}