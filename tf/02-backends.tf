## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/backends.tf ---

# terraform {
#   backend "s3" {
#     bucket = local.tf_state_bucket
#     key    = local.s3_bucket_key
#     region = var.aws_region
#   }
# }

terraform {
  cloud {

    organization = "subhamay-bhattacharyya"

    workspaces {
      name = "0027-scilla-tf"
    }
  }
}