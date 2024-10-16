## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/locals.tf ---

locals {
  public_cidrs  = [for i in range(0, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

locals {
  vpc_endpoints = {
    ssm = {
      name          = "ssm"
      endpoint_type = "Interface"
      service_name  = "com.amazonaws.${var.aws_region}.ssm"
    }
    ec2messages = {
      name          = "ec2messages"
      endpoint_type = "Interface"
      service_name  = "com.amazonaws.${var.aws_region}.ec2messages"
    }
    ssmmessages = {
      name          = "ssmmessages"
      endpoint_type = "Interface"
      service_name  = "com.amazonaws.${var.aws_region}.ssmmessages"
    }
    s3 = {
      name          = "s3"
      endpoint_type = "Gateway"
      service_name  = "com.amazonaws.${var.aws_region}.s3"
    }
    kms = {
      name          = "kms"
      endpoint_type = "Interface"
      service_name  = "com.amazonaws.${var.aws_region}.kms"
    }
    # logs = {
    #   name          = "logs"
    #   endpoint_type = "Interface"
    #   service_name  = "com.amazonaws.${var.aws_region}.logs"
    # }
    # monitoring = {
    #   name          = "monitoring"
    #   endpoint_type = "Interface"
    #   service_name  = "com.amazonaws.${var.aws_region}.monitoring"
    # }
  }
}

locals {
  security_groups = {
    vpc_endpoint_sg = {
      name        = "${var.project_name}-vpc-endpoint-sg"
      description = "VPC Endpoint Security Group"
      ingress = {
        https = {
          name        = "Allows HTTPS"
          description = "Allows inbound traffic from the VPC on port 443."
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = var.vpc_cidr
        }
      }
      egress = {}
    }
    ec2_instance_connect_sg = {
      name        = "${var.project_name}-ec2-instance-connect-sg"
      description = "EC2 Instance Connect Security Group"
      ingress     = {}
      egress = {
        ssh = {
          name        = "Allows SSH"
          description = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = null
        }
      }
    }
    ec2_instance_sg = {
      name        = "${var.project_name}-ec2-instance-sg"
      description = "EC2 Instance Security Group"
      ingress     = {}
      egress = {
        alltcp = {
          name        = "Allows HTTPS"
          description = "Allows outbound traffic to the endpoints on port 443."
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = null
        }
      }
    }
  }
}

locals {
  subnets = [{
    cidr_block = module.networking.outputs.subnets.private[0].cidr_block
    subnet_id  = module.networking.outputs.subnets.private[0].subnet_id
    public     = false
    },
    {
      cidr_block = module.networking.outputs.subnets.public[0].cidr_block
      subnet_id  = module.networking.outputs.subnets.public[0].subnet_id
      public     = true
  }]
}