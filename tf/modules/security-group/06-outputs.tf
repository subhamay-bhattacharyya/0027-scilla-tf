## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- security-group/outputs.tf ---

output "outputs" {
  value = {
    security_group_id  = aws_security_group.security_group.id
    security_group_arn = aws_security_group.security_group.arn
    rules = {
      inbound  = aws_vpc_security_group_egress_rule.sg_egress_rule.*
      outbound = aws_vpc_security_group_ingress_rule.sg_ingress_rule.*
    }
  }
}