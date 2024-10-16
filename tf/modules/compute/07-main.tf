## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- compute/main.tf ---

resource "random_id" "ec2_id" {
  byte_length = 2
  count       = var.instance_count
}

resource "aws_instance" "ec2" {
  count                       = var.instance_count
  instance_type               = var.instance_type
  ami                         = data.aws_ami.ami.id
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnets[count.index].subnet_id
  associate_public_ip_address = var.subnets[count.index].public
  iam_instance_profile        = var.instance_profile
  private_ip                  = join(".", concat(slice(split(".", split("/", var.subnets[count.index].cidr_block)[0]), 0, 3), [100]))
  root_block_device {
    volume_size = var.vol_size # 10
  }

  tags = merge({
    Name = var.subnets[count.index].public ? "${var.project_name}-public${var.ci_build}" : "${var.project_name}-private${var.ci_build}"
  }, local.tags)
}