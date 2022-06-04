pipeline {
  agent any

    environment {
     REGISTRY_TAGS = ""

  }

  stages {

       stage('Parse the current app version') {
         steps {
             echo 'Save the current app version'
                    sh '''
                    echo "Parsing the values.yaml to extract the current 
                          app version and save in a variable ${current_app_version}.
                          Then create an array containing all the available tags in the docker registry"
                    '''
         }
       }


       stage('Update App Version in Chart.yml') {
         steps {
             echo 'App version will be equal to docker image tag'
                    sh '''
                    echo "This should only execute with a "when" clause. 
                    Compare ${current_app_version} with the all the tags in docker registry "
                    '''
         }
       }


       stage('Helm Testing') {
         steps {
                    sh '''
                    echo "Running Helm Lint Command. Parse the output and if there is a failure,
                    Fail the build"
                    '''
         }
       }

       stage('Update Helm Chart version in Chart.yml') {
         steps {
                    sh '''
                    echo "This stage should only progress if the previous stage passed. Also, it must 
                    run on a tag so that the tag version is the same as the helm chart version saved in 
                    Chart.yml file"
                    '''
         }
       }


       stage('Package the code into a Helm Chart') {
        // when { branch pattern: "^feature.*|^bug.*|^dev", comparator: "REGEXP"}
         steps {
                    sh '''
                    echo "Running the helm package command"
                    '''
         }
       }

       stage('Deploy the Helm chart to Non Prod Helm Repository') {
        when {
                expression { BRANCH_NAME ==~ /(integration|develop|main|master)/ }
            }
         steps {
                    sh '''
                    echo "Deploy the helm chart to Non Prod Helm repo in Artifactory"
                    '''
         }
       }

       stage('Release to Production Repository') {
        when { buildingTag() }
         steps {

            script {
              timeout(time: 10, unit: 'MINUTES') {
                input(id: "Continuous Delivery", message: "Release to production?", ok: 'Release')
              }
        }
                    sh '''
                    echo "Release the helm chart to Production Helm repo in Artifactory"
                    '''
         }
       }

    }
}
