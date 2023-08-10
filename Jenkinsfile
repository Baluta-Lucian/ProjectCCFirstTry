pipeline {
	agent any
	stages {
		


	// Develop chain

		stage('Build image with tag latest for main branch') {
			when{
				expression{env.GIT_BRANCH == 'origin/develop'}
			}
			steps{
				script {
					web_app = docker.build("firstccprojecttry/web-app","-f ./docker-folder/Dockerfile ./ ")
				}
			}
		}

		stage('Push image with tag latest for main branch') {
			when{
				expression{env.GIT_BRANCH == 'origin/develop'}
			}
			steps{
				script {
					docker.withRegistry('https://eu.gcr.io', 'gcr:gcr-admin-key') {
						web_app.push("latest")
					}                    
				}
			}
		}

		stage ('Deploy image on main cluster') {
			when{
				expression{env.GIT_BRANCH == 'origin/develop'}
			}
			steps{
				build job: 'deploy-to-k8s'
			}    
		}
	}
}
