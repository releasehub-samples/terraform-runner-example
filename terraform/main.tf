terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "${vars.namespace}/lambda"
}