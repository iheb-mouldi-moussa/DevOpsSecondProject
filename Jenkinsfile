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
                echo '############## UNIT TEST FINISHED #############'
            }
        }
    }
}