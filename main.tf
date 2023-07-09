# organizations structure
resource "aws_organizations_organization" "sandbox" {
  
}

resource "aws_organizations_organizational_unit" "ou_1" {
  name = "ou_1"
  parent_id = aws_organizations_organization.sandbox.roots[0].id
}

resource "aws_organizations_organizational_unit" "ou_2" {
  name = "ou_2"
  parent_id = aws_organizations_organizational_unit.ou_1.id
}

# account definitions
resource "awscc_organizations_account" "dev" {
  account_name = "development"
  email = "stratus.iac.learn@gmail.com"
  parent_ids = [aws_organizations_organizational_unit.ou_1.id]
}

resource "awscc_organizations_account" "prod" {
  account_name = "production"
  email = "gojoekim@gmail.com"
  parent_ids = [aws_organizations_organizational_unit.ou_2.id]
}