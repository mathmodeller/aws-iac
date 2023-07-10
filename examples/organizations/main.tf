# create SCP policy
data "aws_iam_policy_document" "limit_ec2_type" {
    statement {
        effect = "Deny"
        actions = ["ec2:RunInstances"]
        resources = ["arn:aws:ec2:*:*:instance/*"]
        condition {
          test = "StringNotEquals"
          variable = "ec2:InstanceType"
          values = ["t2.micro"]
        }
    }
}
resource "aws_organizations_policy" "free_tier_only" {
  name    = "free_tier_only"
  content = data.aws_iam_policy_document.limit_ec2_type.json
}


# organizations structure
resource "aws_organizations_organization" "sandbox" {

}

# attach scp to ou_1
resource "aws_organizations_organizational_unit" "ou_1" {
  name = "ou_1"
  parent_id = data.aws_organizations_organization.sandbox.roots[0].id
}
resource "aws_organizations_policy_attachment" "unit" {
    policy_id = aws_organizations_policy.free_tier_only.id
    target_id = aws_organizations_organizational_unit.ou_1.id
}

resource "aws_organizations_organizational_unit" "ou_2" {
  name = "ou_2"
  parent_id = aws_organizations_organizational_unit.ou_1.id
}

# account definitions
resource "awscc_organizations_account" "dev" {
  account_name = "dev"
  email = "stratus.iac.learn@gmail.com"
  parent_ids = [aws_organizations_organizational_unit.ou_1.id]
}

resource "awscc_organizations_account" "prod" {
  account_name = "prod"
  email = "gojoekim@gmail.com"
  parent_ids = [aws_organizations_organizational_unit.ou_2.id]
}