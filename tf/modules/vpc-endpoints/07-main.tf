## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- vpc-endpoints/main.tf ---
resource "aws_vpc_endpoint" "vpc_endpoint" {
  for_each            = var.vpc_endpoints
  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.endpoint_type
  route_table_ids     = each.value.name == "s3" ? var.route_table_ids : null
  subnet_ids          = each.value.name != "s3" ? var.subnet_ids : null
  security_group_ids  = each.value.endpoint_type == "Interface" ? var.security_group_ids : null
  private_dns_enabled = each.value.endpoint_type == "Interface" ? true : false

  tags = merge({
    Name = "${var.project_name}-${each.value.name}-endpoint${var.ci_build}"
  }, local.tags)
}
