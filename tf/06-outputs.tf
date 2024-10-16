## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/outputs.tf ---

output "resources" {
  value = {
    networking = module.networking.outputs
    security_group_ids = {
      vpc_endpoint_sg         = module.vpc_endpoint_sg.outputs.*
      ec2_instance_connect_sg = module.ec2_instance_connect_sg.outputs.*
      ec2_instance_sg         = module.ec2_sg.outputs.*
    }
    vpc_endpoints = {
      vpc_endpoints                 = module.vpc_endpoint.outputs.vpc_endpoint
      ec2_instance_connect_endpoint = module.ec2_instance_connect_endpoint.*.outputs.arn
    }
    iam_instance_profile = module.iam.outputs
    ec2_instances        = module.compute.outputs
  }
}
