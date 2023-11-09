pipeline{
    agent{
        node{
            label 'maven'
        }
    }

    stages{
        stage("Build"){
            steps{
                echo "############# BUILD STARTED #############"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '############ BUILD FINISHED #############'
            }
        }
    }
}