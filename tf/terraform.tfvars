## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/terraform.tfvars ---

vpc_cidr         = "10.0.0.0/16"
max_subnet_count = 2
aws_region       = "us-east-1"
access_ip        = "0.0.0.0/0"
instance_count   = 2
volume           = 10
instance_type    = "t2.micro"
iam_policies     = ["AmazonS3FullAccess", "AmazonSSMManagedInstanceCore"]
