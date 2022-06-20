Implementation guide 


1. Create a VPC
2. Create the subnets 
3. Create the Internet Gateway
4. Attach the Internet Gateway to the VPC
5. Create route table for the public subnet to use  (Public Route Table)
6. Create a route in the public route table and point to the Internet gateway
7. Associate the public subnets to the created route table
8. Create a NAT Gateway so that servers in the private subnet can reach the internet to for example download stuff (Outbound)
9. Create route table for the private subnet to use (Private Route Table)
10. Create a route in the created route table and point to the NAT Gateway
11. Associate the private subnets (for compute only) to the private route table
12. Create security group for Bastion. Allow all DevOps engineers to connect over SSH to the Bastion server
13. Create security group and allow the entire world to talk to the ALB
14. Create security group and allow the ALB to talk to the Nginx proxy server.
15. Create an External facing Application Load Balancer (ALB)
16. Create a Listener (port 80) and target group
17. Create a Launch Template for nginx (Use a redhat based AMI)
18. Create ASG for nginx


19. Create a Launch Template for Bastion 
20. Create ASG for Bastion
21. Connect to Bastion server launched in the Public Subnet
22. Connect to the nginx server launched in the Private Subnet
23. create a userdata.sh script to bring up nginx 



```
#!/usr/bin/bash
sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum install -y nginx git
sudo systemctl restart nginx
```

24. Ensure that the nginx Target group is healthy
    1.  Check the security of the instance and ensure it allows port 80
25. Create Route53 entry. Point the DNS to the ALB




26. Create security group for internal ALB. (Alow traffic from Nginx proxy)
27. Create Security group for Wordpress site (Allow traffic from internal ALB)
28. Create Security group for Tooling site (Allow traffic from internal ALB)
29. Create target group for Wordpress site
30. Create target group for tooling site
31. Create internal ALB and configure listeners with Host header rules for both wordpress and tooling sites


32. Configure instance profile and give the tooling and wordpress instances relevant permissions to access AWS resources (for example, S3, EFS)
33. Create Launch Template for Tooling ASG (Ensure the IAM for instance profile is configured)
34. Create Launch Template for Wordpress ASG (Ensure the IAM for instance profile is configured)
35. Create ASG for Tooling instances
36. Create ASG for Wordpress instances
37. Configure nginx to upstream to internal ALB

server {
    listen 80;
    server_name www.mcc-app1.devops-masterclass.link;
    location / {
        proxy_pass http://internal-masterclass-internal-alb-1479104505.eu-west-2.elb.amazonaws.com;
        proxy_set_header Host $host;
    }
}

1.  Create Security Group for EFS - Allow access from Tooling and Wordpress on NFS port
2.  Create IAM Instance Profile
3.  Create EFS File system (SG)
4.  Create EFS Access Point (Optional)
    
5.  Create Security Group for RDS
6.  Create the KMS key for RDS data encryption
7.  Create DB subnet group
8.  Create RDS/Aurora Database








Annex

key=key=/Users/dare/Downloads/mcc-ec2.cer
eval $(ssh-agent) 
ssh-add $key

Mac OS
ssh-add --apple-use-keychain ~/.ssh/devops.cer

Windows
ssh-add ~/.ssh/devops.cer





#!/bin/bash
sudo yum update -y
sudo yum install -y nginx git
sudo systemctl enable nginx
sudo systemctl start nginx
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm

