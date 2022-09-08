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
      releasehub_commit       = var.RELEASE_COMMIT_SHORT
      releasehub_context      = var.RELEASE_CONTEXT
    }
 }
}

#---------------------------------------------------------------------------------------
variable "RELEASE_ACCOUNT_ID" {
  type        = string
  description = "ReleaseHub account ID"
}

variable "RELEASE_APP_NAME" {
  type        = string
  description = "ReleaseHub Application Name"
}

variable "RELEASE_ENV_ID" {
  type        = string
  description = "ReleaseHub Environment ID"
}

variable "RELEASE_BRANCH_NAME" {
  type        = string
  description = "Source control branch that this environment was created from"
}

variable "RELEASE_BUILD_ID" {
  type        = string
  description = "ReleaseHub Build ID for the setup or update workflow causing this Terraform module to run"
}

variable "RELEASE_CLOUD_PROVIDER" {
  type        = string
  description = "ReleaseHub platform of this environment (gcp or aws)"
}

variable "RELEASE_COMMIT_SHA" {
  type        = string
  description = "Commit SHA used to build this current ReleaseHub environment"
}

variable "RELEASE_COMMIT_SHA" {
  type        = string
  description = "Short commit hash from RELEASE_COMMIT_SHA"
}

variable "RELEASE_CONTEXT" {
  type        = string
  description = "Name of the Kubernetes (e.g. EKS or GKE) cluster this environment is pinned to run on"
}

variable "RELEASE_DOMAIN" {
  type        = string
  description = "Unique identifier for the Release environment"
}

#---------------------------------------------------------------------------------------
resource "aws_dynamodb_table" "table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"

  attribute {
    name = "PK"
    type = "S"
  }
}
#---------------------------------------------------------------------------------------

locals {
  # If you need a unique ID for a resource property or output, you might, for example, 
  # use locals to define them once. Depending on the property, you may or may not be able to use
  # slashes or other separators. You may need to limit string length, as well. 
  stack_prefix_dashed = "${var.RELEASE_APP_NAME}-${var.RELEASE_BRANCH_NAME}-${var.RELEASE_ENV_ID}"
  stack_prefix_slashed = "${var.RELEASE_APP_NAME}/${var.RELEASE_BRANCH_NAME}/${var.RELEASE_ENV_ID}"

  # Value length are of course limited and vary depending on the property and resource ,so you 
  # might do something like this, as well: 
  stack_prefix_slashed_64 = substr("${var.RELEASE_APP_NAME}/${var.RELEASE_BRANCH_NAME}/${var.RELEASE_ENV_ID}",0, 64)

}

#---------------------------------------------------------------------------------------

output "table_arn" {
  value = aws_dynamodb_table.arn
}

#---------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "table_arn" {
  name  = "/release/${local.stack_prefix_slashed_64}/table_arn"
  type  = "String"
  value = aws_dynamodb_table.arn
}

