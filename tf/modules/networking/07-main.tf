## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- networking/main.tf ---

# --- Random Shuffle
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnet_count
}

# --- VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = "${var.project_name}-vpc${var.ci_build}"
  }, local.tags)

  lifecycle {
    create_before_destroy = true
  }
}

# --- Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.project_name}-igw${var.ci_build}"
  }, local.tags)
}

# --- Public subnet with Route Table association
resource "aws_subnet" "public_subnet" {
  count                   = var.max_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({
    Name = "public subnet az-${count.index + 1}${var.ci_build}"
  }, local.tags)
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.project_name}-public-rt${var.ci_build}"
  }, local.tags)
}

resource "aws_route_table_association" "public_sn_assoc" {
  count          = var.max_subnet_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# --- Private subnet with Route Table association
resource "aws_subnet" "private_subnet" {
  count                   = var.max_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]


  tags = merge({
    Name = "private subnet az-${count.index + 1}${var.ci_build}"
  }, local.tags)
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.project_name}-private-rt${var.ci_build}"
  }, local.tags)
}

resource "aws_route_table_association" "private_sn_assoc" {
  count          = var.max_subnet_count
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_rt.id
}

# --- Network Access Control List with private and public subnet association
resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge({
    Name = "${var.project_name} subnet nacl${var.ci_build}"
  }, local.tags)
}

resource "aws_network_acl_association" "nacl_association_pvt" {
  count          = var.max_subnet_count
  network_acl_id = aws_network_acl.nacl.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_network_acl_association" "nacl_association_pub" {
  count          = var.max_subnet_count
  network_acl_id = aws_network_acl.nacl.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
