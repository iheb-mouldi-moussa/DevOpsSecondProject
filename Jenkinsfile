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


        stage(Artifactory)
        {
            steps
            {

                echo '####################### PUSHING ARTIFACT STARTING ########################3'
                script
                {
                    def server = Artifactory.newServer url: 'https://husseinaon.jfrog.io/artifactory', credentialsId: 'Jenkins-To-JFrog'
                    def uploadSpec = """{
                      "files": [
                        {
                          "pattern": "com/valaxy/demo-workshop/2.1.2/(*)",
                          "target": "libs-release-local/"
                          "exclusions": [ "*.sha1", "*.md5"]
                        }
                     ]
                    }"""
                }
                echo '####################### PUSHING ARTIFACT ENDING ########################3'
            }
        }
        /*stage("Artifactory")
        {
            steps
            {
                echo '####################### PUSHING ARTIFACT STARTING ########################3'
                    rtServer (
                     id: 'maven-server',
                     url: 'https://husseinaon.jfrog.io/artifactory',
                     credentialsId: 'Jenkins-To-JFrog',
                    )

                    rtUpload (
                        serverId: 'maven-server',
                        spec: '''{
                              "files": [
                                {
                                  "pattern": "/home/ubuntu/jenkins/workspace/test-multi-branch_master/jarstaging/com/valaxy/demo-workshop/2.1.2",
                                  "target": "libs-release-local"
                                }
                             ]
                        }''',

                        // Optional - Associate the uploaded files with the following custom build name and build number,
                        // as build artifacts.
                        // If not set, the files will be associated with the default build name and build number (i.e the
                        // the Jenkins job name and number).
                        buildName: 'holyFrog',
                        buildNumber: '42'
                    )

                echo '################ PUSHING ARTIFACTS ENDED ##############################'
            }
        }*/


    }
}