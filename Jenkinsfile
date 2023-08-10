pipeline {
	agent any
	environment {
		PROJECT = "firstccprojecttry"
		CLUSTER_NAME = "firstccprojecttry-gke-cluster"
		LOCATION = "europe-west3-a"
		gcp_project_name = "firstccprojecttry"
		microservice_name = "web-app"
		gcr_url = 'https://eu.gcr.io'
		JENKINS_CRED = "${PROJECT}"
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
					web_app = docker.build("${env.gcp_project_name}/${env.microservice_name}","-f ./docker-folder/Dockerfile ./docker-folder")
					echo "${web_app}"
				}
			}
		}

		stage('Push image with tag latest for main branch') {
// 			when{
// 				expression{env.GIT_BRANCH == 'origin/main'}
// 			}
			steps{
				script {
					docker.withRegistry("${env.gcr_url}", "gcr:gcr-admin-key") {
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
				step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: "gcr-admin-key", verifyDeployments: true]) 
					echo "Deployment Finished ..."
			}    
		}
	}
}
