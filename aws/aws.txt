SERVICES: EC2, EBS, ELB, VPC, S3, RDS, AUTOSCALING, CLOUDWATCH.

----------------------------------------------------------------------- AWS EC2 & EBS --------------------------------------------------------------------------

>> AMI - Amazon machine image provides the information required to launch the instance, which is a virtual server in the cloud.

>> Instance type - The instance type specified determines the hardware of the host computer used for your instance

>> EBS - EC2 provides data storage option for our instances called Elastic block store.

>>Tag - Simple label consisting of key and value to manage, search & filter resources.

1. To create ec2 instance:

Choose AMI --> Choose Instance type --> Configure instance --> Add storage --> Add tags --> Configure security group --> Review


EBS - ELASTIC BLOCK STORE (EBS Volume & Snapshot)

1. Types of EBS:
 
>> General purpose (SSD) - Most work loads

>> Magnetic - Slowest & cheapest, mostly used for backup.


2. Create mount and attach EBS storage for EC2 instance.

$ fdisk -l : List all available disk spaces
 
$ df -h : To check the filesystem mounted

$ fdisk /dev/xvdf1 : Hardisk path is passed to fdisk utility to create partition mount
- n : to add new partition
- p : partition type as primary
- 1 : partition number as one
- p : print partition table
- w : write (create partion)

$ mkfs.ext4 /dev/xvdf1 : format the partition with extention 4.

$ mount /dev/xvdf1 /var/lib/disk : temperory mount the partition on path /var/lib/disk

$ vi /etc/fstab : permanenet mount the partition on path /var/lib/disk

/dev/xvdf1 	/var/lib/disk	ext4	defaults	0 0

$ mount -a : apply the mount changes

3. SNAPSHOT

>> Snapshot is used to take backup of the volume create
>> The backup taken as snapshot can be used to recreate the EBS volume in same or other AZ.


------------------------------------------------------------------ Security Group & Keypairs -------------------------------------------------------------------

Security Group:

>> A security group acts as a virtual firewall for your EC2 instances to control incoming and outgoing traffic. 
>> Inbound rules control the incoming traffic to your instance.
>> Outbound rules control the outgoing traffic from your instance. 

Key pairs:

>> Consists of a public key and a private key, is a set of security credentials that you use to prove your identity when connecting to an Amazon EC2 instance.

----------------------------------------------------------------------- AWS RDS ---------------------------------------------------------------------------------

- DB Administration: Installs, Monitoring, Performance tuning, Backups, Scaling, Security.

** RDS is a distributed relational database service.
** High availability Multi-AZ Deployment.
** Effortless scaling

- Amazon Aurora is a Mysql and PostgreSQL compatible enterprise class database.


----------------------------------------------------------------------- AWS VPC ---------------------------------------------------------------------------------

>> VPC is a logical datacenter within an AWS region.
>> Control over network environment, select IP address range, subnets and configure route tables and gateways.
>> Subnet: A large section of IP Address divided in to chunks are known as subnets

1. Private IP ranges:

Class A: 10.0.0.0 - 10.255.255.255
Class B: 172.16.0.0 - 172.31.255.255
Class C: 192.168.0.0 - 192.168.255.255

2. Subnet masks: Decides the range of an IP address.

example: ip - 192.168.0.0, subnet mask - 255.255.255.0

>> Since the 4th octet of subnet mask is 0, the ip address 4th octet will range from 0 to 255.

192.168.0.0  => Network IP
192.168.0.1  => First usable IP
192.168.0.2
...
...
...
192.168.0.254 => Last usable IP
192.168.0.255 => Broadcast

Total IP = 256
Total usable  IP = 254

example: IP - 10.23.12.56, subnet mask - 255.0.0.0

10.0.0.0
10.0.0.1
...
...
10.255.255.254
10.255.255.255

Total IP -256 * 256 * 256 = 1,67,77,216

3. CIDR - Classless internet domain routing

Decimal subnet mask: 255.255.255.0 
Binary subnet mask:  11111111.11111111.11111111.00000000
CIDR notation: "/8", "/16", "/24"


a) 255.0.0.0
   11111111.00000000.00000000.00000000
   /8
   
b) 255.255.0.0
   11111111.11111111.00000000.00000000
   /16
   
c) 255.255.255.0
   11111111.11111111.11111111.00000000
   /24
   
example: 172.20.0.0/16 (first 2 octet are for network & last 2 are for host)

Network range - 
172.20.0.0/16
subnets - 
172.20.0.0/24
172.20.1.0/24
172.20.2.0/24
172.20.3.0/24
172.20.4.0/24


4. VPC Design and Components:

a. Network Address Translation(NAT): 

>> Gateway to enable instances in a private subnet to connect to the internet or other AWS services.
>> NAT Gateway does something similar to IGW, but it only works one way: Instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.

b. Internet gateway: 

>> Is a horizontally scaled, redundant and highly available VPC component that allows communication between instances in your VPC and internet.
>> Internet Gateway enables resources (like EC2 instances) in public subnets to connect to the internet
>> If a VPC doesn't have an IGW, then the resources in the VPC cannot be accessed from the Internet (unless the traffic flows via a Corporate Network and VPN)


5. VPC Setup 

>> REQUIREMENTS TO CREATE A VPC

- Region: us-west-1
- VPC Range 172.20.0.0/16
- 4 subnets: 2 public subnets, 2 private subnets
- 2 zones: us-west-1a, us-west-1b 

172.20.1.0/24    => public-subnet-1 [us-west-1a] - 256 total IP (5 reserved by AWS and 251 useable)
172.20.2.0/24    => public-subnet-2 [us-west-1b]
172.20.3.0/24    => private-subnet-1 [us-west-1a]
172.20.4.0/24    => private-subnet-2 [us-west-1b]

- 1 Internet Gateway
- 2 NAT Gateway
- 1 Elastic IP 
- 2 Route Tables : 1 Public Subnet Route Table, 1 Private Subnet Route Table
- 1 Bastion host(jump server) in Public subnet -> To access instances in private subnet

- NACL: Network access control table for public subnet 
>> Its like firewall, security group is for instance and NACL is for subnet which gives more control
>> Security group has only "ALLOW" rule but NACL has both "ALLOW" and "DENY" rule.

- 1 more VPC => VPC Peering



>> STEPS TO CREATE VPC (ONE PRIVATE AND ONE PUBLIC SUBNET)

step 1: Create VPC with any name and network range (CIDR block 172.20.0.0/16)

- Use ip range of 172.20.0.0/16 which has 256*256 ip's to access
- This creates a route table which is a default route table and a NACL

step 2: Create two public subnets inside this VPC

- Create 1st public subnet with 172.20.1.0/24 ipv4 IP in us-west-1a region. Here 251 ip is available and 5 are reserved by AWS.
- Create 2nd public subnet with 172.20.2.0/24 ipv4 IP in us-west-1b region for HA.

step 3: Create two private subnets inside this VPC

- Create 1st private subnet with 172.20.3.0/24 ipv4 IP in us-west-1a region
- Create 2nd private subnet with 172.20.4.0/24 ipv4 IP in us-west-1b region

step 4: Create a IGW for public subnet and attach it to the vpc.

- To attach this IGW with subnet is done by route table. So create route table in next step.

step 5: Create a route table 1 in this VPC to attach IGW to public subnet.

- Goto Subnet association & Edit subnet association and select the 2 public subnets to be attached.
- Edit routes and add destination = 0.0.0.0/0 and target = IGW. Here destination = 172.20.0.0/16 target = local will be present by default.
- So this vpc has ip range 172.20.0.0/16 set as local target, where traffic is routed locally and anything apart from this (0.0.0.0/0) will be routed to IGW, which makes it a public subnet

step 6: Create NAT gateway for private subnet by selecting subnet as public (since NAT gateway resides in public subnet).

- Select the 1st public subnet to create the NAT gateway in it.
- Allocate an Elastic IP to this NAT gateway.

step 7: Create a route table 2 in this VPC to attach NAT gateway to private subnet.

- Edit subnet association and select the 2 private subnets to be attached.
- Edit routes and add destination = 0.0.0.0/0 and target = NAT gateway. Here destination = 172.20.0.0/16 target = local will be present by default.
- So this vpc has ip range 172.20.0.0/16 set as local target, where traffic is routed locally and anything apart from this (0.0.0.0/0) will be routed to NAT.


step 8: Launch a EC2 instance to host web application server in private subnet by selecting the custom VPC created above.

- This ec2 instance is to be created inside private subnet to host web server application.
- Create a security group for this ec2 instance called "vprofile-web".
- This instance will have only private ip and connecting to this ec2 instance which is in private subnet is through a bastion or jump server(using ssh)
- Update the security group of web server, add inbound rule as bastion host ip (private ip) type = ssh.


step 9: Launch a instance for Bastion server (which will get or assigned a public ip by default)

- Create a security group called "bastion/jump server"
- The private ip of this bastion host should be added to the security group of web server to make ssh connection.


step 10: Create Loadbalancer in public subnets inside the custom vpc for web server created above.

- This LoadBalancer is created for web server.
- The web server security group should allow connection from LoadBalancer.
- Go to security group of web server instance and edit inbound rule to add port "80" from LoadBalancer security group.


6. VPC Peering

- Connecting two VPC either from same or different AWS account.
- A VPC peering connection helps you to facilitate the transfer of data.
- if you have more than one AWS account, you can peer the VPCs across those accounts to create a file sharing network.
- EC2 instances in different AWS Regions can communicate with each other using private IP addresses, without using a gateway, VPN connection, or network appliance



7. NACL - Network Access 

- Its like firewall, security group is for instance and NACL is for subnet which gives more control
- Security group has only "ALLOW" rule but NACL has both "ALLOW" and "DENY" rule.




----------------------------------------------------------------------- AWS S3 ----------------------------------------------------------------------------------

>> AWS S3 (Simple storage service) is storage for the internet used to store and retrieve any amount of data any time anywhere on web.
>> AWS S3 Stores data as objects within buckets.
>> Bucket name has to be unique.

1. Creation of S3

AWS S3 --> Bucket (give unique name) --> Region --> Folder --> object --> Public access

2. Types of storage classes

- S3 standard: General purpose storage of frequently accessed data. Fast access and object replication in multi AZ.
- S3 IA (Infrequent access): Long lived but less frequently accessed data. Slow access, object replication in multi AZ.
- S3 one zone IA: Is for data that is accesssed less frequently.
- S3 Intelligent Tiering: Automatically moves data to most cost effective tier.
- S3 Glacier: Low cost storage class for data archiving.

3. Lifecycle policies

>> Data gets shifted from one storage class to other based on its age.

S3 standard --> (after 30days) --> S3 IA --> (after 30days) --> S3 Glacier


4. EC2 Logs (Archive the logs and move it to s3 storage using AWS CLI)

- STEP 1: Install AWS CLI

	$ yum install awscli

- STEP 2: Create IAM role for EC2 with only s3 service access as programatic access (IAM role doesn't require secret key or access keys like IAM users)

	a). Create an IAM role with by selecting common use case as EC2 (using this role we will use ec2 to access s3 service)
	b). Create policy in next step to give full access of S3 service to EC2.
	c). Give a role name to attach this role to our ec2 instance.
	d). Go to EC2 instance > Actions > Security > Modify IAM role > Select the IAM role name created > Save
	

- STEP 3: Login to EC2 instance and access the S3 services from there.

	$ aws configure

	$ aws s3 ls - List all the buckets in aws account.

- STEP 4: Copy archive files to s3 storage using cp and sync command.

	$ aws s3 cp /tmp/logs/log_18-02-23.tar.gz s3://wave-logs/logs_18-02-23.tar.gz

	$ aws s3 sync /tmp/logs s3://wave-logs


5. Store LoadBalancer logs in S3 by using Bucket policy.


{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::elb-account-id:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::bucket-name/prefix/AWSLogs/your-aws-account-id/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::bucket-name/prefix/AWSLogs/your-aws-account-id/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::bucket-name"
    }
  ]
}



-------------------------------------------------------------- ELASTIC LOADBALANCER (ELB) & DNS ---------------------------------------------------------------

>> LOADBALANCER PORTS

Frontend port: Listens from the user requests on this port aka Listeners. eg - 80,443,25 etc

Backend port: Service running on OS listening on this port. eg - tomcat server 8080, 443

>> ELB: 

Elastic load balancing distributes incoming application or network traffic across multiple targets such as Amazon EC2 instances, containers and IP addresses in multiple availaible zones.
		
>> Types of ELB:
	
1. Classic Loadbalancer: 

** Classic Loadbalancer that routes traffic based on either application or network level information.
** Classic Load balancer is ideal for simple load balancing of traffic across multiple EC2 instance.

2. Application Loadbalancer:

** Routes traffic based on advanced application level information that includes the content of the request.
** Layer 7 of the OSI model

3. Network Loadbalancer

** It can handle millions of requests per second and has provides static IP.
** Layer 4 of the OSI model - Transport layer


------------------------------------------------------------------ CLOUDWATCH -----------------------------------------------------------------------------------

Cloud Watch - Monitor performance of AWS environment - standard infrastructure metrics.

SNS - send notification service to send mail when alert is trigggered on instances.

1. Uses of CloudWatch

a). Metrics

>> AWS CloudWatch allows to record metrics for services such as EBS, EC2, ELB, Route53, RDS & S3.

b). Events

>> AWS events delivers a near real-time stream of system events that describe changes in AWS resources.

c). Logs

>> AWS CloudWatch Logs can be used to monitor, store and access log files from EC2 and other sources.



2. CloudWatch Service to get email notification for cpu utilization.


>> By default CloudWatch service will monitor CPU metrics every 5mins. So detailed monitoring has to be enabled if metrics is required every 1 minute.

>> Steps to setup email notification alarm 

CloudWatch service > Create alarm > Select metric > Select ec2 instance > Give period & Instance id(ec2) >  Select email id for alerts




----------------------------------------------------------- AUTOSCALING --------------------------------------------------------------------------------------

1. AUTOSCALING: 

>> Autoscalling is a service that automatically monitors and adjusts compute resource to maintain performance for application hosted in AWS.

2. Launch Template:

>> Launch Template is an instance configuration template that an Auto scaling group uses to launch EC2 instances.

3. Autoscaling group

- Minimum size
- Desired capacity
- Maximum size


2. Steps to ennable AUTOSCALING in AWS


AMI --> Launch Template --> Target group --> LoadBalancer --> Autoscalling group

- STEP 1: Create an AMI Image 

>> AMI will consist of [Instance + Metadata] which will be used to launch EC2 instances eveytime.


- STEP 2: Create a Launch Template

>> For creating Launch template give the AMI/image ID that is previously created.


- STEP 3: Create a Target group.

>> GO TO Target group and create an empty target group without any instances, Autoscalling will add instances in this target group automatically.


- STEP 4: Create a LoadBalancer for the Target group.

>> Application LoadBalancer has to be created with forwarding option selected as the target group created.


- STEP 5: Create the Autoscaling group

A. Select the Launch template that is already created. (We can have multiple version of Launch template).

B. Attach the Launch template with LoadBalancer using Target group that we created.

C. Configure the scaling policy with Desired, Minimum & Maximum capacity.



Note: How to make any changes on instances when Autoscaling is on ?

>> Autoscaling uses Lauch Template where pre-configured AMI is setup. So any changes has to made always in Lauch Template either change the configured AMI or use different version of Launch Template.