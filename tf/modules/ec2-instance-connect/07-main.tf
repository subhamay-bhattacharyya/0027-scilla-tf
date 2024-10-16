## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- ec2-instance-connect/main.tf ---

resource "aws_ec2_instance_connect_endpoint" "ec2_instance_connect_endpoint" {
  count              = length(var.private_subnets)
  subnet_id          = var.private_subnets[count.index]
  security_group_ids = var.security_group_ids

  tags = merge({
    Name = "${var.project_name}-eice-${count.index + 1}"
  }, local.tags)
}
