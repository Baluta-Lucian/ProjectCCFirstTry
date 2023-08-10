pipeline {
	agent any
	stages {

		stage('Checkout scm') {
			steps {
				checkout scm
			}
		}
		
        // stage('Test branch') {
        //     steps{
        //         echo "${env.GIT_BRANCH}"
        //     }
        // }
        
		stage('Build image with tag latest for main branch') {
// 			when{
// 				expression{env.GIT_BRANCH == 'origin/main'}
// 			}
			steps{
				script {
					web_app = docker.build("${gcp_project_name}/${microservice_name}","-f ./docker-folder/Dockerfile ./ ")
				}
			}
		}

		stage('Push image with tag latest for main branch') {
// 			when{
// 				expression{env.GIT_BRANCH == 'origin/main'}
// 			}
			steps{
				script {
					docker.withRegistry("${gcr_url}", "gcr:${gcr_admin_key}") {
						web_app.push("latest")
					}                    
				}
			}
		}

		stage ('Deploy image on main cluster') {
// 			when{
// 				expression{env.GIT_BRANCH == 'origin/main'}
// 			}
			steps{
				build job: 'deploy-to-k8s'
			}    
		}
	}
}
