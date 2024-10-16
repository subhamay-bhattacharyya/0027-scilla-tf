## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- ec2-instance-connect/variables.tf ---

######################################## EC2 Instance Connect Endpoint #############################
variable "private_subnets" {
  type        = list(string)
  description = "The ID of the subnet in which to create the EC2 Instance Connect Endpoint."
}
variable "security_group_ids" {
  type        = list(string)
  description = "security groups to associate with the endpoint."
}
######################################## Project Name ##############################################
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "scilla"
}
######################################## Environment Name ##########################################
variable "environment_name" {
  type        = string
  description = <<EOT
  (Optional) The environment in which to deploy our resources to.

  Options:
  - devl : Development
  - test: Test
  - prod: Production

  Default: devl
  EOT
  default     = "devl"

  validation {
    condition     = can(regex("^devl$|^test$|^prod$", var.environment_name))
    error_message = "Err: environment is not valid."
  }
}
######################################## GitHub Variables ##########################################
variable "github_repo" {
  type        = string
  description = "GitHub Repository Name"
  default     = ""
}
variable "github_url" {
  type        = string
  description = "GitHub Repository URL"
  default     = ""
}
variable "github_ref" {
  type        = string
  description = "GitHub Ref"
  default     = ""
}
variable "github_sha" {
  type        = string
  description = "GitHub SHA"
  default     = ""
}
variable "github_wf_run_num" {
  type        = string
  description = "GitHub Workflow Run Number"
  default     = ""
}
variable "ci_build" {
  type        = string
  description = "Ci Build String"
  default     = ""
}

