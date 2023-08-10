pipeline {
	agent any
	environment {
		CLUSTER_NAME = 'firstccprojecttry-gke-cluster'
		LOCATION = 'europe-west3-a'
	}
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
				step([$class: 'KubernetesEngineBuilder', projectID: "${gcp_project_name}", clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', verifyDeployments: true]) 
					echo "Deployment Finished ..."
			}    
		}
	}
}
