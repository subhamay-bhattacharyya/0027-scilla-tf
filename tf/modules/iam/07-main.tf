## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - Scilla
## Project Description                  - AWS Networking - VPC fundamentals - Creating a custom VPC, Subnet, Internet 
##                                        Gateway, NAT Gateway, Route Table,NACL, Security Group, Gateway and Interface 
##                                        Endpoints
## Modification History:
##   - 1.0.0    Sep 30,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- iam/main.tf ---

resource "aws_iam_role" "iam_role" {
  name               = "${var.project_name}-ec2-role${var.ci_build}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge({
    Name = "${var.project_name}-ec2-role${var.ci_build}"
  }, local.tags)
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  count      = length(var.iam_policies)
  policy_arn = "arn:aws:iam::aws:policy/${var.iam_policies[count.index]}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile${var.ci_build}"
  role = aws_iam_role.iam_role.name
}