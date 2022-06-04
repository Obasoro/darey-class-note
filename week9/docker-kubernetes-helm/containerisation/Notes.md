-- Docker is a platform for building, running and shipping applications 
-- Solves the problem - "It works on my machine" - Due to - One or more files missing - Software dependency (node, mongo, nginx etc...) or Kernel version mismatch 
-- Runs the application inside an isolated environment called "Container" 
-- A part of your application can run java 8 while another runs version 10 without messing with each other 
-- If there is need to decommission a part of an application, we can easily do that without messing with the entire application 
-- we can safely clean up our development machine with all the downloaded dependencies wihthout problems 
-- Containers and Virtual Machines 
    -- VM - abstration of a physical computer through a hypervisor (Virtualbox, VMWare) - Each machine needs an operating system that needs to be Licensed, Patched and maintanined (A lot of overhead) - slow to start - Resource Intensive (cpu, memory and disk space) 
    
    -- Containers - Same isolation like VM, but more lightweght - Needs only one Operating system that requires maintenance - Fast to load - Needs much less hardware resources 

Docker Architecture -- CLient server architecture 
  - Client talks to the Docker Engine which is the server 
  - Docker engine sits in the background and takes care of running containers 
    - containers are like special processes running on a computer 
    - Containers are created from a template called Docker image 
    - All the containers share the kernel of the Operating system 
    - A kernel is the core software of the Operating system (the part of the Operating system that manages all the applications, and hardware resources like Memory and CPU)
  
Development Workflow 

1. Package applications into a template called an "Image" using a Dockerfile 
   -- Command - Docker build 
   - An image contains 
     1. A cut-down OS 
     2. A runtime environment (java, node) 
     3. Application files 
     4. Third-party libraries 
     5. Environment variables. 
   
2. Push the image to a registry. Just like pushing your code to a git repository.
3. Pull and Start a container using an image (Container is a special process running on the machine) 
   - Docker run (Test to Production) - Run a simple image that is already published to Docker hub - hub.docker.com 
4.  Create a Dockerfile to run a simple NodeJs application 
   -- Template to build a dockerfile 
       - Start with an OS 
       - Install Node 
       - Copy app files 
       - Run the application file app.js 
            FROM node:alpine 
            RUN mkdir /app
            COPY . /app 
            WORKDIR /app 
            CMD node app.js
  -- Build the image 
      build -t hello-docker .
  -- See the image 
    docker images or docker image ls 
  -- Run the image as a container 
    docker run hello-docker
  -- Publish the image to docker hub 
    Docker push dareyregistry/hello-docker
  -- Play with docker - labs.play-with-docker.com

Hands On Excercises

1. docker pull mysql/mysql-server:latest
2. docker images ls
3. docker run --name mysql-server-container -e MYSQL_ROOT_PASSWORD=mysqlPassword -d mysql/mysql-server:8.0.27-aarch64
4. docker ps -a
5. docker exec -it mysql-server-container mysql -uroot -p
6. docker network create --subnet=172.18.0.0/24 tooling_app_network 
7. export MYSQL_PW=mysqlPassword

8.  docker run --network tooling_app_network -h mysqlserverhost --name=mysql-server -e MYSQL_ROOT_PASSWORD=$MYSQL_PW  -d mysql/mysql-server:latest 


9.  echo "CREATE USER 'clientConnect'@'%' IDENTIFIED BY 'password@@@@@';
    GRANT ALL PRIVILEGES ON * . * TO 'clientConnect'@'%';" >> ./create_user.sql


10. docker exec -i mysql-server mysql -uroot -p$MYSQL_PW < ./create_user.sql


11. docker run --network tooling_app_network --name mysql-client -it --rm mysql mysql -h mysqlserverhost -u <user-created-from-the-SQL-script> -p

--name gives the container a name
-it runs in interactive mode and Allocate a pseudo-TTY
--rm automatically removes the container when it exits
--network connects a container to a network
-h a MySQL flag specifying the MySQL server Container hostname
-u user created from the SQL script
-p password specified for the user created from the SQL script


12. export tooling_db_schema=<path-to-tooling-schema-tile>/tooling_db_schema.sql
13. docker exec -i mysql-server mysql -uroot -p$MYSQL_PW < $tooling_db_schema
14. Update the db_conn.php file with connection details to the database
$servername = "mysqlserverhost";
$username = "<user>";
$password = "<client-secret-password>";
$dbname = "toolingdb";
15. docker build -t tooling:0.0.1 .
16. docker run --network tooling_app_network -p 8085:80 -it tooling:0.0.1
17. Home-Work https://github.com/darey-devops/php-todo
18. Introduce Docker compose - Create a file, name it docker-compose.yaml

-- Containerisation was designed for stateless applications 
-- The opposite of stateless is stateful
-- Containers are Ephemeral. They dont run for long, hence are prone to die from time to time

version: "3.9"
services:
  tooling_frontend:
    build: .
    ports:
      - "5000:80"
    volumes:
      - tooling_frontend:/var/www/html
    links:
      - db
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: <The database name required by Tooling app >
      MYSQL_USER: <The user required by Tooling app >
      MYSQL_PASSWORD: <The password required by Tooling app >
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql
volumes:
  tooling_frontend:
  db:


1.  docker-compose -f docker-compose.yaml  up -d 
2.  docker compose ls
3.  Kubernetes Architecture
    1.  A powerful yet very complex framework for running and orchestrating containerised application across multiple computers
    2.  The entire setup consists of Master and Slave/Worker nodes to form a single cluster
        1.  Master or Control: 
          -- Scheduling the containers on the nodes in the cluster -- Identify the right nodes to run workload
          -- Plans which of the workers is best suited to run the workload
          -- Administering the containers, and the nodes running the containers. (Tracking information about them, where they are, what resources are they using...etc)
          -- Uses different softwares to do all its work. Control plane components (Master node's Microservices)
            1.  Scheduler
                a.  Which worker node is adequate to handle a container based on the container's resource requirement and node's resource constraints?
            2.  Controller-Manager
                a.  Node-controller (Onboarding and decommissioning nodes in the cluster)
                b.  Replication Controller (Desired number of containers are running at all times)
            3.  Kube-Api-Server (Primary Management Component)
                a.  Exposes the kubernetes API so that we can interact with Kubernetes. Like the entry point into the cluster
                b.  Manages the entire communications between the various components in the cluster. Like the brain of a human, or CPU of a computer.
                c.  The worker nodes communicates with the cluster through the kube-apiserver
            4.  etcd Database (Key- Value store)
        2. Slaves/Workers: Running and monitoring the containers
           1. Kubelet
              a. Managing all activities on the worker node
              b. Runs on all the worker nodes in the cluster
              c. Listens for instructions from the kube-apiserver, and executes actions to either destroy or run containers on the server
              d. The kube-apiserver periodically fetches status reports from the kubelets so as to know the status of the node and the containers running on it.
           2. Kube-proxy
              a. Handles communication between containers running on the node and other nodes
              b. ensures the necessary rules are configured to allow smooth communication to occur between containeers running across the different nodes
           3. Container runtime engine (Docker, containerd, rocket, etc...)
              1. The smallest unit of deployment in a kubernetes cluster is called a "Pod" Containers run inside it, and it is the docker runtime engine that kubernetes uses to run the containers. 
              2. At the end of the day, Kubernetes is about Orchestration. Meaning, orchestrating how containers run across different nodes in such an organised and smooth manner.
            


4.  Minikube
    1.  Deploy nginx app
5.  Kubernetes the hard way
6.  Deploy tools into kubernetes 
    1.  https://gitlab.com/darey.io/pbl-expert/-/blob/master/projects/source/project22.md
    2.  https://gitlab.com/darey.io/pbl-expert/-/blob/master/projects/source/project23.md (Helm)
        1.  Deploy Jenkins 
        2.  Artifactory
        3.  Hashicorp Vault
        4.  Prometheus
        5.  Grafana
        6.  Elasticsearch ELK using ECK
        7.  Kubernetes key concepts
            1.  Services - CLusterIP, NodeIP, Loadbalancer
            2.  Difference between stateful and stateless apps
            3.  Statesfull sets, Replicasets

7.   You will write custom Helm charts
8.   Configure Ingress for all the tools and applications running in the cluster
9.   Integrate Secrets management using Hashicorp Vault
10.  Integrate Logging with ELK
11.  Inetegrate monitoring with Prometheus and Grafana
12.  Learn Jenkins as code











7. An overview of CICD
   -- echo "Building the software"
   -- echo "Testing the software (Unit Testing)"
   -- echo "Implementing Quality Gate Checks"
   -- echo "Deploying the software to Non-Production Environment only from Feature Branch"
   -- echo "Deploying the software to Integration Environment from Develop branch for further integration tests"
   -- echo "Run Integration Tests"
   -- echo "Deploying the software to Production Environment from Master branch or a Git Tag"
   -- echo "Notify the team upon success or failure of the pipeline"

8. A more intuitive  CICD Pipeline
   -- You will have pipeline for different software repositories and projects. For example
      -- Dockerfiles or Software binaries
      -- Helm charts
      -- Terraform code etc...

   -- Blue Ocean Plugin
   -- Pipeline for Tooling docker image 


9.  Helm for Tooling app 
   -- Mysql 
   helm install mysql bitnami/mysql
   - Configure the database and user for the application 
  echo CREATE USER 'clientConnect'@'%' IDENTIFIED BY 'password@@@@@';
    GRANT ALL PRIVILEGES ON * . * TO 'clientConnect'@'%';

  Image pull secret

  kubectl create secret docker-registry dockercred \
  --docker-username=<your-name> \
  --docker-password=<your-pword> \



7. Access from port forwarding
8. Deploy Ingress controller
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm upgrade -i ingress-nginx bitnami/nginx-ingress-controller --version 9.1.3
















Branch 'Project/v7'

1. Deploy Jenkins
    -- helm repo add jenkins https://charts.jenkins.io
    -- helm repo update 
    -- helm install jenkins jenkins/jenkins

2. Deploy Artifactory 
   -- helm repo add jfrog https://charts.jfrog.io
  - helm repo update
  helm upgrade -i artifactory jfrog/artifactory



- Upgrade with the PostgreSQL Password  
  Get the postgresSQL Passsword 

  POSTGRES_PASSWORD=$(kubectl get secret -n default artifactory-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
  
  Perform the upgrade below 
  helm upgrade artifactory jfrog/artifactory --set postgresql.postgresqlPassword=${POSTGRES_PASSWORD} --namespace default --set databaseUpgradeReady=true

3. - Remove the loadbalancer and Use Ingress instead
helm upgrade artifactory jfrog/artifactory --set postgresql.postgresqlPassword=${POSTGRES_PASSWORD} --namespace default --set databaseUpgradeReady=true \
        --set nginx.service.type=ClusterIP

4. Deploy Ingress Controller 
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install nginx-ingress bitnami/nginx-ingress-controller

  -- Enable Prometheus monitoring for Ingress Controller 
     helm upgrade -i nginx-ingress bitnami/nginx-ingress-controller --set metrics.enabled=true

5. Deploy Ingress for Artifactory

6. Configure Route 53
   
7. Configure TLS Manually - Openssl

-- Create certificates (Resource https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)
-- Create TLS secret of TLS type

8. Implement Cert-manager
  Deploy Cert-manager  -- https://cert-manager.io/docs/installation/helm/ or https://artifacthub.io/packages/helm/cert-manager/cert-manager
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm upgrade -i \
        cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --create-namespace \
        --version v1.6.1 \
        --set installCRDs=true

9.  Deploy Ingress resource for Jenkins
     kubectl apply -f /Users/dare/Downloads/aws-project-darey/docker-kubernetes-helm/containerisation/k8s/project-v7/ingress/jenkins.yaml

10. Access Jenkins from company URL

11.  Deploy Cluster issuer for TLS 

12. Add Annotations to Ingress so that cert-manager can now be used. Check the certificates have been issued by Lets Encrypt
  
        Troubelshooting tips
    -- kubectl get/describe certificate
    -- kubectl get/describe certificaterequest
    -- kubectl get/describe order
    -- kubectl get/describe challenge
        -- Check that the DNS is resolving - https://dnschecker.org/

13.  Access the services on https

-- Monitoring

13. Prometheus
       helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
       helm install prometheus prometheus-community/prometheus --version 15.0.4 
       -- Deploy prometheus Ingress (Might take a while for the certs and url to work properly)




14. Grafana 
        helm repo add grafana https://grafana.github.io/helm-charts
        helm upgrade -i grafana grafana/grafana --version 6.20.6
        -- Configure prometheus datasource
        -- import dashboard manually 
            8760 - Kubernetes Cluster
            1621 - Kubernetes Cluster monitoring
            1860 - Very detailed Node Monitoring
            6336 - Kubernetes pods 
            5309 - Kubernetes capacity
            7187 - Kubernetes resource requests
            9614 - Nginx-Ingress-Controller

        -- Update helm values to automatically configure prometheus and import dashbaord - Get Values from Artifact.io
        
        helm upgrade -i grafana grafana/grafana --version 6.20.6 -f /Users/dare/Downloads/aws-project-darey/docker-kubernetes-helm/containerisation/k8s/helm/values/grafana.yaml

        -- Deploy RPC application
        -- Configure prometheus further (Alerts, metrics, etc...)


        -- Simulate 2XX requests
        while true
        do
          sleep 1
          curl -I https://sample-app.devops-masterclass.link/
        done


        -- Simulate 5XX requests
        while true
        do
          sleep 1
          curl -I https://sample-app.devops-masterclass.link/do-not-exists
        done


        -- Infinite calls
        while true
        do
          wget -q -O- https://sample-app.devops-masterclass.link/
        done

        while true
        do
          curl -I https://sample-app.devops-masterclass.link/do-not-exists
        done


        while true
        do
          curl -I https://sample-app.devops-masterclass.link/do-not-exists
        done


      kubectl run -i --tty load-generator-1 --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://rpc-app-service; done"
      kubectl run -i --tty load-generator-2 --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- https://sample-app.devops-masterclass.link/do-not-exists; done"

      kubectl run -i --tty load-generator-3 --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- pet-clinic-app.devops-masterclass.link; done"

      kubectl run -i --tty load-generator-4 --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://rpc-app-service; done"


        kubectl run -i --tty load-generator-6 --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- hello-app-service; done"



15. Deploy Kubernetes Metrics Server 
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm upgrade -i metrics-server bitnami/metrics-server --version 5.10.14

    helm upgrade --namespace default metrics-server bitnami/metrics-server \
        --set apiService.create=true

16. Pod autoscaler
    kubectl apply -f /Users/dare/Downloads/aws-project-darey/docker-kubernetes-helm/containerisation/k8s/monitoring/tutorials/lessons/013/07-sample-app/hpa.yaml



Statefulsets 

software clusters are hardcoded with host names

1. Guaranty the order at which pods startup 
2. Static hostname not random names

statefulsets 

1. Pods are created ins equential order - From 1 to xxx
2. Unique ordinal index - sticky identity



Cluster Autoscaler 
https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md






17. Vault
   1. Vault in single and HA mode using consul - Configure auto unseal with AWS KMS

18. Deploy Tooling app with Helm
19. Create CICD for tooling app images - Jenkinsfile for dockerimage - Deployment into different environments (Namespaces)
20. Jenkins Job for Helm deployment -  Deployment into different environments (Namespaces)
21. Introduce GitOps with FluxCD
    1.  auto deploy docker images on push
    2.  auto update helm releases
22. Monitoring the infrastructure
23. Logging infrastructure


24. Implement secrets management using HAshicorp Vault





















Home work 
-- Configure Artifactory as a docker repository 

docker tag 

docker pull / push docker-repo.artifactory.tooling.devops-masterclass.link/tooling:0.0.1
docker login -u <USER_NAME> -p <USER_PASSWORD> docker-repo.artifactory.tooling.devops-masterclass.link

-- Implement CICD for more applications

1. Implement CICD for Tooling app 
   1. PHP application 
   2. Depends on a MySQL backend database 

-- Build the docker image and push to a private repository in Artifactory 
-- Build Helm chart to deploy the applications (MySQL and Tooling)
-- Promote to different environments



docker login artifactory.tooling.devops-masterclass.link
docker tag <IMAGE_ID> artprod.mycompany/<DOCKER_REPOSITORY>:<DOCKER_TAG>

docker push artprod.mycompany/<DOCKER_REPOSITORY>:<DOCKER_TAG>



Advanced Kubernetes concepts

1. Pod Distruption budgets
2. Affinitis
3. Node Selectors

Interview Prep
Job Search


