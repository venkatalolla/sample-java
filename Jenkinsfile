node()
{
    cleanWs()
    dir("sourcecode")
    {
        stage('Source Code Checkout')
        { 
            // Git check out the sample java application repository to sourcecode directory
            git changelog: false, credentialsId: 'Github', poll: false, url: 'https://github.com/venkatalolla/sample-java.git'
        }

        // Global version variable concatinating from VERSION file
        version = sh (script: "cat VERSION", returnStdout: true) + "." + "${env.BUILD_NUMBER}"

        stage('Build')
        {
            // Build the application using Maven
            withMaven(maven: 'maven') 
            {
                sh "mvn clean install -Drelease.version=${version}"
            }
        }

        stage('Build Docker Image')
        {
            // Build the Dockerfile
            sh "docker build . -t suryalolla/java-app:${version}"        
        }

        stage('Docker Push')
        {
            // Push the docker image to docker hub
            sh "docker push suryalolla/java-app:${version}"
        }
    }

    dir("helmchart")
    {
        stage('Helm Generic Charts Checkout')
        {
            // Git check out the generic helm charts to helmchart directory
            git changelog: false, credentialsId: 'Github', poll: false, url: 'https://github.com/venkatalolla/helm-generic-templates.git'
        }

        stage('Helm Package')
        {
            // Copy the required values file from source code directory 
            sh "cp ${WORKSPACE}/sourcecode/values.yaml ${WORKSPACE}/helmchart/java-app/"

            // Helm Chart previous version number in Chart.yaml file
            perviousversion = sh (script: "awk '/version/ {print \$2}' ${WORKSPACE}/helmchart/java-app/Chart.yaml", returnStdout: true)

            // Update the previous version number with new version number in Chart.yaml file
            sh "sed -i 's/${perviousversion}/${version}/g' ${WORKSPACE}/helmchart/java-app/Chart.yaml" 

            // Package the helm chart
            sh "helm package ${WORKSPACE}/helmchart/java-app"
        }

        stage('Helm Chart Publish')
        {
            // Publish Helm Charts to S3 repository
            sh "helm s3 push java-app-${version}.tgz remote-charts"
        }
    }
}