pipeline{
    agent{
        node{
            label 'maven'
        }
    }

    environment{
        PATH = "/opt/maven/bin:$PATH"
    }
    stages{
        stage("Build"){
            steps{
                echo "############# BUILD STARTED #############"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '############ BUILD FINISHED #############'
            }
        }

        stage("Test")
        {
            steps{
                echo '############# UNIT TEST STARTED ##############'
                sh 'mvn surefire-report:report'
                echo '############## UNIT TEST FINISHED ############'
            }
        }

        stage("SonarQube Analysis")
        {
            environment
            {
                scannerHome = tool 'sonarqube-scanner'
            }
            steps
            {
                withSonarQubeEnv('sonarqube-server')
                {
                    sh '${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=iheb-mouldi-moussa_DevOpsSecondProject \
                    -Dsonar.projectName=DevOpsSecondProject \
                    -Dsonar.organization=iheb-mouldi-moussa \
                    -Dsonar.java.binaries=target/classes'
                }
            }
        }

       /* stage("Quality Gate")
        {
            steps
            {
                timeout(time: 1, unit: 'HOURS')
                {
                    waitForQualityGate abortPipeline: true
                }
            }
        }*/

        stage("Artifactory")
        {
            script
            {
                rtServer (
                 id: 'maven-server',
                 url: 'https://husseinaon.jfrog.io/artifactory',
                     // If you're using username and password:
                 username: 'user',
                 password: 'password',
                 // If Jenkins is configured to use an http proxy, you can bypass the proxy when using this Artifactory server:
                 bypassProxy: true,
                 // Configure the connection timeout (in seconds).
                 // The default value (if not configured) is 300 seconds:
                 timeout: 300
                )

                rtUpload (
                    serverId: 'maven-server',
                    spec: '''{
                          "files": [
                            {
                              "pattern": "/home/ubuntu/jenkins/workspace/test-multi-branch_master/jarstaging/com/valaxy/demo-workshop/2.1.2",
                              "target": "maven-remote/"
                            }
                         ]
                    }''',

                    // Optional - Associate the uploaded files with the following custom build name and build number,
                    // as build artifacts.
                    // If not set, the files will be associated with the default build name and build number (i.e the
                    // the Jenkins job name and number).
                    buildName: 'holyFrog',
                    buildNumber: '42',

                )
            }
        }


    }
}