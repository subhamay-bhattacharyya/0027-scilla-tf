## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- security-group/main.tf ---
resource "aws_security_group" "security_group" {
  name        = join("", [var.security_group["name"], var.ci_build])
  description = var.security_group["description"]
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({
    Name = join("", [var.security_group["name"], var.ci_build])
  }, local.tags)
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  for_each                     = var.security_group["ingress"]
  security_group_id            = aws_security_group.security_group.id
  cidr_ipv4                    = each.value["cidr_blocks"] != null ? each.value["cidr_blocks"] : null
  referenced_security_group_id = each.value["cidr_blocks"] == null ? var.referenced_sg_id_ingress : null
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from
  to_port                      = each.value.to
  description                  = each.value.description
  tags = {
    "Name" : each.value.name
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  for_each                     = var.security_group["egress"]
  security_group_id            = aws_security_group.security_group.id
  cidr_ipv4                    = each.value["cidr_blocks"] != null ? each.value["cidr_blocks"] : null
  referenced_security_group_id = each.value["cidr_blocks"] == null ? var.referenced_sg_id_egress : null
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from
  to_port                      = each.value.to
  description                  = each.value.description
  tags = {
    "Name" : each.value.name
  }
}