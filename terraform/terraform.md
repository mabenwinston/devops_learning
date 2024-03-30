--------------------------------------------------------------------Introduction--------------------------------------------------------------------------------

1. IAC - Infrastructure as code | Automate Infrastructure
2. Define Infrastructure state and maintain it.
3. Ansible, chef or puppet automates mostly os related tasks | These define machine state
4. Terraform automates infra itself like AWS, Azure, GCP
5. Terraform works with automation software like Ansibe after infra is setupand ready.

Terraform file to launch ec2 instance:

provider "aws" {
	region = "us-east-2"
	#access_key = ""
	#secret_key = ""
}

resource "aws_instance" "intro" {
	ami = "ami-04929448849ab940"
	instance_type = "t2.micro"
	availaibility_zone = "us-east-2a"
	key_name = "dove-key"
	vpc_security_groups_ids = ["sg-07929383939e8a"]
	tags = {
		Name = "Dove-Instance"
		Project = "Dove"
	}
}

$ terraform init - Check for provider (aws) and download the required plugins
$ terraform validate - Check the syntax of the tf file
$ terraform fmt - Change the format of tf file (in order)
$ terraform plan - Show the preview of execution
$ terraform apply - Apply the changes
$ terraform show - Inspect the current state
$ terraform destroy - Delete the resources


>> Terraform maintains state of infrastructure by "terraform.tfstate" file and compares with remote to apply any changes if present.


----------------------------------------------------------------- Variables -------------------------------------------------------------------------------------

>> Move secrets to another file
>> Values that change: AMI, tags, keypair
>> Reuse your code


1. provider.tf: Uses "REGION" as variable from vars.tf file

provider "aws" {
	region = "var.REGION"
}

2. instance.tf:

resource "aws_instance" "intro" {
	ami = var.AMI[var.REGION]
	instance_type = "t2.micro"
}

3. vars.tf:

variable REGION {
	default = "us-west-1"
}

variable AMI {
	type = map
	default = {
		us-west-1 = "ami-0628292028393"
		us-west-2 = "ami-a0838373"
	}
}

------------------------------------------------------------------------ PROVISIONING & OUTPUT --------------------------------------------------------------

>> Build custom images with tools like packer
>> Use standard image and use provisioner to setup softwares: 
	a. File upload
	b. remote_exec 
	c. ansible, puppet & chef

>> Provisioners:
	a. remote_exec - invokes a command/script on remote resource
	b. local_exec - provisioner invokes a local executable after a resource is created.
	
1. vars.tf

variable REGION {
  default = "us-east-2"
}

variable ZONE1 {
  default = "us-east-2a"
}

variable AMIS {
  type = map
  default = {
    us-east-2 = "ami-03657b56516ab7912"
    us-east-1 = "ami-0947d2ba12ee1ff75"
  }
}

variable USER {
  default = "ec2-user"
}

2. provider.tf

provider "aws" {
	region = "var.REGION"
}

3. web.sh

#!/bin/bash
yum install wget unzip httpd -y
systemctl start httpd
systemctl enable httpd
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html/
systemctl restart httpd

4. instance.tf

resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}

resource "aws_instance" "dove-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = ["sg-0780815f55104be8a"]
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}

output "PublicIP" {
  value = aws_instance.dove-inst.public_ip
}

output "PrivateIP" {
  value = aws_instance.dove-inst.private_ip
}


------------------------------------------------------------------------ Backend -------------------------------------------------------------------------------

>> To Maitain state (tf files) of the infrastructure the tf files are stored in centralized area like s3 bucket from where all team can work.

1. backend.tf

terraform {
  backend "s3" {
    bucket = "terra-state-dove"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}


>> Locking the state files in terraform 

1. In this example, dynamodb_table specifies the DynamoDB table used for locking. DynamoDB is used to manage locks when working with S3 as a backend.

2. Create DynamoDB Table (if using S3): If you're using S3 as a backend with DynamoDB for locking, you'll need to create a DynamoDB table named terraform_locks (or the name you specified in the configuration).


terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "terraform/state.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform_locks"
  }
}




------------------------------------------------------------------------ Multi resource ------------------------------------------------------------------------


1. vpc.tf

resource "aws_vpc" "dove" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dove-vpc"
  }
}

resource "aws_subnet" "dove-pub-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-pub-1"
  }
}

resource "aws_subnet" "dove-pub-2" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "dove-pub-2"
  }
}


resource "aws_subnet" "dove-pub-3" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "dove-pub-3"
  }
}


resource "aws_subnet" "dove-priv-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-priv-1"
  }
}


resource "aws_subnet" "dove-priv-2" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "dove-priv-2"
  }
}


resource "aws_subnet" "dove-priv-3" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "dove-priv-3"
  }
}

resource "aws_internet_gateway" "dove-IGW" {
  vpc_id = aws_vpc.dove.id
  tags = {
    Name = "dove-IGW"
  }
}

resource "aws_route_table" "dove-pub-RT" {
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dove-IGW.id
  }

  tags = {
    Name = "dove-pub-RT"
  }
}


resource "aws_route_table_association" "dove-pub-1-a" {
  subnet_id      = aws_subnet.dove-pub-1.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

resource "aws_route_table_association" "dove-pub-2-a" {
  subnet_id      = aws_subnet.dove-pub-2.id
  route_table_id = aws_route_table.dove-pub-RT.id
}
resource "aws_route_table_association" "dove-pub-3-a" {
  subnet_id      = aws_subnet.dove-pub-3.id
  route_table_id = aws_route_table.dove-pub-RT.id
}



2. web.sh


#!/bin/bash
yum install wget unzip httpd -y
systemctl start httpd
systemctl enable httpd
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html/
systemctl restart httpd


3. vars.tf

variable REGION {
  default = "us-east-2"
}

variable ZONE1 {
  default = "us-east-2a"
}

variable ZONE2 {
  default = "us-east-2b"
}

variable ZONE3 {
  default = "us-east-2c"
}

variable AMIS {
  type = map
  default = {
    us-east-2 = "ami-03657b56516ab7912"
    us-east-1 = "ami-0947d2ba12ee1ff75"
  }
}

variable USER {
  default = "ec2-user"
}

variable PUB_KEY {
  default = "dovekey.pub"
}

variable PRIV_KEY {
  default = "dovekey"
}

variable MYIP {
  default = "183.83.67.89/32"
}


4. secgrp.tf


resource "aws_security_group" "dove_stack_sg" {
  vpc_id      = aws_vpc.dove.id
  name        = "dove-stack-sg"
  description = "Sec Grp for dove ssh"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  tags = {
    Name = "allow-ssh"
  }
}


5. providers.tf


provider "aws" {
  region = var.REGION
}


6. instance.tf


resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file(var.PUB_KEY)
}

resource "aws_instance" "dove-web" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dove-pub-1.id
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove_stack_sg.id]
  tags = {
    Name = "my-dove"
  }
}

resource "aws_ebs_volume" "vol_4_dove" {
  availability_zone = var.ZONE1
  size              = 3
  tags = {
    Name = "extr-vol-4-dove"
  }
}

resource "aws_volume_attachment" "atch_vol_dove" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_4_dove.id
  instance_id = aws_instance.dove-web.id
}

output "PublicIP" {
  value = aws_instance.dove-web.public_ip
}


6. backend.tf

terraform {
  backend "s3" {
    bucket = "terra-state-dove"
    key    = "terraform/backend_exercise6"
    region = "us-east-2"
  }
}



------------------------------------------------------- Terraform Import ---------------------------------------------------------------------------------


Terraform supports importing existing resources added through console changes into its state so that you can manage them using Terraform configurations.

terraform import <Terraform resource identifier> <resource id>

terraform import aws_s3_bucket.my_bucket my_bucket_name




-------------------------------------------------- Route 53 -------------------------------------------------------------------------------------------------


provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create a Route 53 hosted zone
resource "aws_route53_zone" "example_zone" {
  name = "example.com"
}

# Create an A record within the hosted zone
resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = ["1.2.3.4"]  # Replace with your desired IP address
}
