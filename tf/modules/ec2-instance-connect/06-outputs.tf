## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- ec2-instance-connect/outputs.tf ---

output "outputs" {
  value = {
    arn = aws_ec2_instance_connect_endpoint.ec2_instance_connect_endpoint.*
  }
}