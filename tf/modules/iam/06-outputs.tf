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
    instance_profile_arn = aws_iam_instance_profile.iam_instance_profile.arn
    instance_profile     = aws_iam_instance_profile.iam_instance_profile.name
    iam_role_arn         = aws_iam_role.iam_role.arn
  }
}