terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = vars.aws_region
}

module "lambda_function" {
  function_name                     = substr("${vars.namespace}-terraform-runner-example", 0, 64)
  source                            = "terraform-aws-modules/lambda/aws"
  description                       = "Sample Lambda function created by ReleaseHub demo app"
  handler                           = "index.handler"
  runtime                           = "nodejs14.x"
  source_path                       = "./lambda"
  policy_path                       = "/release/"
  role_path                         = "/release/"
  role_name                         = "${vars.namespace}-lambda"
}