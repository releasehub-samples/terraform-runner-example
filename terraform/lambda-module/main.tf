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

variable "RELEASE_CLUSTER_REGION" {
  type        = string
  description = "ReleaseHub platform of this environment (gcp or aws)"
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
module "lambda_function" {
  source                            = "terraform-aws-modules/lambda/aws"
  description                       = "Demo function created with Terraform via ReleaseHub"
  handler                           = "index.handler"
  runtime                           = "nodejs14.x"
  source_path                       = "./lambda"
  policy_path                       = "/release/"   # Required namespace for IAM, unless you assume/pass a custom role
  role_path                         = "/release/"   # same as above
  role_name                         = "lambda"
  cloudwatch_logs_retention_in_days = 30
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

output "lambda_function_arn" {
  value = module.lambda_function.service_arn
}

#---------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "lambda_service_arn" {
  name  = "/release/${local.stack_prefix_slashed_64}/lambda_arn"
  type  = "String"
  value = module.ecs-fargate.service_arn
}

