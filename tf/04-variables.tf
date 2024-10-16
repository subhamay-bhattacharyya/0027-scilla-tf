## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/variables.tf ---

variable "aws_region" {
  type    = string
  default = "us-east-1"
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
######################################## KMS Key ###################################################
variable "kms_key_alias" {
  description = "KMS Key Alias"
  type        = string
  default     = "SB-KMS"
}
######################################## VPC #######################################################
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "max_subnet_count" {
  type        = number
  description = "Maximum number of subnets allowed to create"
}
######################################## Security Group ############################################
variable "access_ip" {
  type    = string
  default = "0.0.0.0/0"
}
######################################## EC2 #######################################################
variable "instance_count" {
  type        = string
  description = "Number of EC2 instances to be spinned up."
}
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}
variable "volume" {
  type        = number
  description = "EBS Volume"
}
######################################## Instance profile attached policies ########################
variable "iam_policies" {
  type        = list(string)
  description = "List of IAM prolicies"
}
