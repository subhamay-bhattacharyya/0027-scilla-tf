## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/main.tf ---

# -- VPC, Subnets, Route Tables, NACL, Internet Gateway
module "networking" {
  source            = "./modules/networking"
  aws_region        = var.aws_region
  vpc_cidr          = var.vpc_cidr
  max_subnet_count  = var.max_subnet_count
  public_cidrs      = local.public_cidrs
  private_cidrs     = local.private_cidrs
  vpc_endpoints     = local.vpc_endpoints
  project_name      = var.project_name
  environment_name  = var.environment_name
  github_repo       = var.github_repo
  github_url        = var.github_url
  github_ref        = var.github_ref
  github_sha        = var.github_sha
  github_wf_run_num = var.github_wf_run_num
  ci_build          = var.ci_build
}

# --------------------------------------          Security Groups     -----------------------------#
# --  VPC endpoint security group
module "vpc_endpoint_sg" {
  source            = "./modules/security-group"
  security_group    = local.security_groups["vpc_endpoint_sg"]
  vpc_id            = module.networking.outputs.vpc.vpc_id
  project_name      = var.project_name
  environment_name  = var.environment_name
  github_repo       = var.github_repo
  github_url        = var.github_url
  github_ref        = var.github_ref
  github_sha        = var.github_sha
  github_wf_run_num = var.github_wf_run_num
  ci_build          = var.ci_build
}

# -- EC2 security group
module "ec2_sg" {
  source                  = "./modules/security-group"
  security_group          = local.security_groups["ec2_instance_sg"]
  vpc_id                  = module.networking.outputs.vpc.vpc_id
  referenced_sg_id_egress = module.vpc_endpoint_sg.outputs.security_group_id
  project_name            = var.project_name
  environment_name        = var.environment_name
  github_repo             = var.github_repo
  github_url              = var.github_url
  github_ref              = var.github_ref
  github_sha              = var.github_sha
  github_wf_run_num       = var.github_wf_run_num
  ci_build                = var.ci_build
}

# -- EC2 instance connect security group
module "ec2_instance_connect_sg" {
  source                  = "./modules/security-group"
  security_group          = local.security_groups["ec2_instance_connect_sg"]
  vpc_id                  = module.networking.outputs.vpc.vpc_id
  referenced_sg_id_egress = module.ec2_sg.outputs.security_group_id
  project_name            = var.project_name
  environment_name        = var.environment_name
  github_repo             = var.github_repo
  github_url              = var.github_url
  github_ref              = var.github_ref
  github_sha              = var.github_sha
  github_wf_run_num       = var.github_wf_run_num
  ci_build                = var.ci_build
}
# --------------------------------------          Security Groups     -----------------------------#

## Add security group rule to allow inbound SSH traffic from EC2 Instance Connect Endpoint to EC2 instance
resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  security_group_id            = module.ec2_sg.outputs.security_group_id
  referenced_security_group_id = module.ec2_instance_connect_sg.outputs.security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  description                  = "Allows inbound traffic from ec2 instance connect endpoints on port 22."
  tags = {
    "Name" : "Allows SSH"
  }
}

## Add security group rule to allow outbound HTTPS traffic from EC2 Instance to S3 prefix list
resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  security_group_id = module.ec2_sg.outputs.security_group_id
  prefix_list_id    = [for k, v in module.vpc_endpoint.outputs.vpc_endpoint[0] : v.prefix_list_id if k == "s3"][0]
  # referenced_security_group_id = module.ec2_instance_connect_sg.outputs.security_group_id
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  description = "Allows outbound traffic from ec2 instance security group to s3 prefix list."
  tags = {
    "Name" : "Allows HTTPS"
  }
}

# --  EC2 instance connect endpoint
module "ec2_instance_connect_endpoint" {
  source             = "./modules/ec2-instance-connect"
  private_subnets    = module.networking.outputs.subnets.private.*.subnet_id
  security_group_ids = [module.ec2_instance_connect_sg.outputs.security_group_id]
  project_name       = var.project_name
  environment_name   = var.environment_name
  github_repo        = var.github_repo
  github_url         = var.github_url
  github_ref         = var.github_ref
  github_sha         = var.github_sha
  github_wf_run_num  = var.github_wf_run_num
  ci_build           = var.ci_build
}

# --  VPC Endpoints in private subnet
module "vpc_endpoint" {
  source             = "./modules/vpc-endpoints"
  vpc_endpoints      = local.vpc_endpoints
  vpc_id             = module.networking.outputs.vpc.vpc_id
  subnet_ids         = module.networking.outputs.subnets.private.*.subnet_id
  security_group_ids = module.vpc_endpoint_sg.outputs.*.security_group_id
  route_table_ids    = [module.networking.outputs.vpc.main_route_table_id, module.networking.outputs.route_table.public_rt.route_table_id, module.networking.outputs.route_table.private_rt.route_table_id]
  project_name       = var.project_name
  environment_name   = var.environment_name
  github_repo        = var.github_repo
  github_url         = var.github_url
  github_ref         = var.github_ref
  github_sha         = var.github_sha
  github_wf_run_num  = var.github_wf_run_num
  ci_build           = var.ci_build
}

#-- EC2 Instance Profile
module "iam" {
  source            = "./modules/iam"
  iam_policies      = var.iam_policies
  project_name      = var.project_name
  environment_name  = var.environment_name
  github_repo       = var.github_repo
  github_url        = var.github_url
  github_ref        = var.github_ref
  github_sha        = var.github_sha
  github_wf_run_num = var.github_wf_run_num
  ci_build          = var.ci_build
}

#-- EC2 Instances

module "compute" {
  source            = "./modules/compute"
  instance_count    = var.instance_count
  subnets           = local.subnets
  security_group_id = module.ec2_sg.outputs.security_group_id
  instance_type     = var.instance_type
  instance_profile  = module.iam.outputs.instance_profile
  vol_size          = var.volume
  project_name      = var.project_name
  environment_name  = var.environment_name
  github_repo       = var.github_repo
  github_url        = var.github_url
  github_ref        = var.github_ref
  github_sha        = var.github_sha
  github_wf_run_num = var.github_wf_run_num
  ci_build          = var.ci_build
}