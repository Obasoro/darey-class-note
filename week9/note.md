1. About Helm 
2. Accessing services in kubernetes through the Ingress
   1. Deploying the Ingress Controller with Helm
   2. Connecting DNS(Route53) with Ingress Controller Load Balancer (Proxy)
3. Deploy an application into the cluster (Jenkins) 
   1. Helm to install Jenkins
   2. Ingress resource for jenkins
4. Secure the application with TLS
   1. Deploy Cert-manager
   2. Deploy Certificate Cluster Issuer
   3. Configure the ingress to automatically secure the service