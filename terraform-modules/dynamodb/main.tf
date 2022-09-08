#---------------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

#---------------------------------------------------------------------------------------
provider "aws" {
  region = "${var.RELEASE_CLUSTER_REGION}"
   default_tags {
	  tags = {
      releasehub_managed      = "true"
      releasehub_account      = var.RELEASE_ACCOUNT_ID
      releasehub_application  = var.RELEASE_APP_NAME
      releasehub_environment  = var.RELEASE_ENV_ID
      releasehub_branch       = var.RELEASE_BRANCH_NAME
      releasehub_context      = var.RELEASE_CONTEXT
      terraform_stack_desc    = "Example DynamoDB Module"
    }
 }
}

#---------------------------------------------------------------------------------------

# If you create multiple resources of the same type in the same stack, you may need additional uniqueness
# if unique values aren't already somehow generated. A random ID is one way to solve this (you'd need 
# one for each resource). You can add a prefix.
# NOTE - you'll want to use keepers, which say "do not generate a new value unless one or more of these
# other keeper values changes." Without this, you'll end up generating a new value and recreating existing
# resources on each terraform apply / environment update.
resource "random_id" "example_table_name" {
  byte_length = 8
  prefix = "releasehub-${var.RELEASE_ENV_ID}-"
  keepers = {
    # As these values shouldn't change between deployments of the same environment,
    # they're good candidates for keepers.
    release_app_name = var.RELEASE_APP_NAME
    release_branch_name = var.RELEASE_BRANCH_NAME
    release_env_id = var.RELEASE_ENV_ID
  }
}

#---------------------------------------------------------------------------------------
resource "aws_dynamodb_table" "example_table" {
  name         = random_id.example_table_name.hex
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"

  attribute {
    name = "PK"
    type = "S"
  }
}

#---------------------------------------------------------------------------------------

locals {
  release_unique_prefix_slashed = "/releasehub/${var.RELEASE_APP_NAME}/${var.RELEASE_BRANCH_NAME}/${var.RELEASE_ENV_ID}"
}

# We can also write outputs to a place like AWS Parameter Store for visibility or integration with other services: 
resource "aws_ssm_parameter" "example_table_name" {
  name  = "${local.release_unique_prefix_slashed}/example_table_name"
  type  = "String"
  value = aws_dynamodb_table.example_table.id
}

# Or use native TF outputs:
output "table_arn" {
  value = aws_dynamodb_table.example_table.id
}