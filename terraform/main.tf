terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "lambda_function" {
  function_name                     = "terraform-runner-blog"
  source                            = "terraform-aws-modules/lambda/aws"
  description                       = "Demo function created with Terraform Runner via Release"
  handler                           = "index.handler"
  runtime                           = "nodejs14.x"
  source_path                       = "./lambda"
  policy_path                       = "/release/"
  role_path                         = "/release/"
  role_name                         = "lambda"
  cloudwatch_logs_retention_in_days = 30
}
