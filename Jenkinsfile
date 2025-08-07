pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-docker-registry/my-nginx"
        GIT_REPO = "https://github.com/your-org/gitops-example.git"
        ARGOCD_SERVER = "argocd.example.com"
        ARGOCD_AUTH_TOKEN = credentials('argocd-token')
        DOCKERHUB_CREDS = 'dockerhub-creds'
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Deploy environment')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag to deploy')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDS) {
                        def appImage = "${DOCKER_IMAGE}:${params.IMAGE_TAG}"
                        docker.build(appImage).push()
                    }
                }
            }
        }

        stage('Update Kustomize Image Tag') {
            steps {
                script {
                    def kustomizePath = "apps/${params.ENVIRONMENT}/kustomization.yaml"
                    def kustomizeContent = readFile(kustomizePath)
                    def newContent = kustomizeContent.replaceAll(/newTag: .*/, "newTag: ${params.IMAGE_TAG}")
                    writeFile(file: kustomizePath, text: newContent)

                    sh "git config user.email 'jenkins@example.com'"
                    sh "git config user.name 'jenkins'"
                    sh "git add ${kustomizePath}"
                    sh "git commit -m 'Update image tag to ${params.IMAGE_TAG} for ${params.ENVIRONMENT}'"
                    sh "git push origin HEAD:${params.ENVIRONMENT}"
                }
            }
        }

        stage('Trigger Argo CD Sync') {
            steps {
                sh """
                argocd login ${ARGOCD_SERVER} --insecure --auth-token ${ARGOCD_AUTH_TOKEN}
                argocd app sync my-nginx-${params.ENVIRONMENT}
                argocd app wait my-nginx-${params.ENVIRONMENT} --health --timeout 300
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment to ${params.ENVIRONMENT} succeeded!"
        }
        failure {
            echo "❌ Deployment to ${params.ENVIRONMENT} failed."
        }
    }
}
