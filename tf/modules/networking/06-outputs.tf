## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- networking/outputs.tf ---

output "outputs" {
  value = { vpc = {
    name                   = aws_vpc.vpc.tags["Name"]
    vpc_id                 = aws_vpc.vpc.id
    cidr_block             = aws_vpc.vpc.cidr_block
    dhcp_options_id        = aws_vpc.vpc.dhcp_options_id
    main_route_table_id    = aws_vpc.vpc.main_route_table_id
    default_network_acl_id = aws_vpc.vpc.default_network_acl_id
    instance_tenancy       = aws_vpc.vpc.instance_tenancy
    owner_id               = aws_vpc.vpc.owner_id
    },
    igw = {
      name   = aws_internet_gateway.igw.tags["Name"]
      igw_id = aws_internet_gateway.igw.id
      arn    = aws_internet_gateway.igw.arn
    }
    subnets = {
      public = [for i in range(0, length(aws_subnet.public_subnet)) : {
        name       = aws_subnet.public_subnet[i].tags["Name"]
        subnet_id  = aws_subnet.public_subnet[i].id
        cidr_block = aws_subnet.public_subnet[i].cidr_block
        arn = aws_subnet.public_subnet[i].arn }
      ]
      private = [for i in range(0, length(aws_subnet.private_subnet)) : {
        name       = aws_subnet.private_subnet[i].tags["Name"]
        subnet_id  = aws_subnet.private_subnet[i].id
        cidr_block = aws_subnet.private_subnet[i].cidr_block
        arn = aws_subnet.private_subnet[i].arn }
      ]
    },
    nacl : {
      name           = aws_network_acl.nacl.tags["Name"]
      network_acl_id = aws_network_acl.nacl.id
      arn            = aws_network_acl.nacl.arn
      subnet_association = {
        public_subnets  = aws_network_acl_association.nacl_association_pub.*.id
        private_subnets = aws_network_acl_association.nacl_association_pvt.*.id
      }
    }
    route_table : {
      public_rt : {
        name : aws_route_table.public_rt.tags["Name"]
        route_table_id : aws_route_table_association.public_sn_assoc[0].route_table_id
        association_id : aws_route_table_association.public_sn_assoc.*.id
        subnet_association : aws_route_table_association.public_sn_assoc.*.subnet_id
        routes : [{
          destination : aws_route.public_route.destination_cidr_block
          target : aws_route.public_route.gateway_id
          status : aws_route.public_route.state
        }]
      }
      private_rt : {
        name : aws_route_table.private_rt.tags["Name"]
        route_table_id : aws_route_table_association.private_sn_assoc[0].route_table_id
        association_id : aws_route_table_association.private_sn_assoc.*.id
        subnet_association : aws_route_table_association.private_sn_assoc.*.subnet_id
      }
    }
  }
}
