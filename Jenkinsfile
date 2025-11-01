pipeline {
environment { // Declaration of environment variables
DOCKER_ID = "sparaccae" // replace this with your docker-id
DOCKER_IMAGE = "datascientestapi"
DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
}
agent any // Jenkins will be able to select all available agents
stages {
  stage(' Docker Build'){ // docker build image stage
    steps {
      script {
      sh '''
        docker rm -f jenkins || true
        docker build --no-cache --pull -t $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG .
        # NEW: tagghiamo anche "latest" localmente così possiamo pubblicarla e riutilizzarla
        docker tag $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE:latest
      sleep 6
      '''
      }
    }
  }
  stage('Docker run'){ // run container from our builded image
    steps {
      script {
      sh '''
      docker rm -f jenkins || true
      # NEW: durante i test eseguiamo la versione appena buildata (locale) per evitare dipendenze dal registry
      docker run -d -p 80:80 --name jenkins $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
      sleep 10
      '''
      }
    }
  }
  stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
    steps {
      script {
      sh '''
      curl localhost
      '''
      }
    }
  }
  stage('Docker Push'){ //we pass the built image to our docker hub account
    environment
    {
      DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
    }
    steps {
      script {
        sh '''
          echo "$DOCKER_PASS" | docker login -u "$DOCKER_ID" --password-stdin
          docker push $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
          # NEW: pubblichiamo anche "latest" così il runtime può forzare sempre l'ultima versione
          docker push $DOCKER_ID/$DOCKER_IMAGE:latest
          docker logout
        '''
      }
    }
  }
  stage('Docker restart from registry (latest)'){ // NEW: riavviamo prendendo "latest" dal registry per mostrare sempre l'ultima versione
    steps {
      script {
      sh '''
      docker rm -f jenkins || true
      # NEW: --pull=always garantisce che venga scaricata l'ultima "latest" appena pushata
      docker run --pull=always -d -p 80:80 --name jenkins $DOCKER_ID/$DOCKER_IMAGE:latest
      sleep 10
      '''
      }
    }
  }
  stage('Deploiement en dev'){
    environment {
    KUBECONFIG = credentials("config") // we retrieve  kubeconfig from sec
