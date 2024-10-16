## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- compute/outputs.tf ---

output "outputs" {
  value = {
    instances = [for i in range(0, var.instance_count) : {
      name           = aws_instance.ec2[i].tags["Name"]
      arn            = aws_instance.ec2[i].arn
      instance_state = aws_instance.ec2[i].arn
      instance_id    = aws_instance.ec2[i].id
      }
    ]
  }
}