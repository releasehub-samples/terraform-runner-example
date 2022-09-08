terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
    }
  }

  required_version = "~> 1.0"
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
      terraform_stack_desc    = "Example Lambda Module"
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
resource "random_id" "example_resource_name" {
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
module "lambda_function" {
  function_name = random_id.example_resource_name.hex
  source                            = "terraform-aws-modules/lambda/aws"
  description                       = "Demo function created with Terraform via ReleaseHub"
  handler                           = "index.handler"
  runtime                           = "nodejs14.x"
  source_path                       = "./hello-lambda"
  policy_path                       = "/release/"   # Required namespace for IAM, unless you assume/pass a custom role
  role_path                         = "/release/"   # same as above
  role_name                         = random_id.example_resource_name.hex
  cloudwatch_logs_retention_in_days = 30
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = random_id.example_resource_name.hex
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = module.lambda_function.lambda_function_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}


resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = random_id.example_resource_name.hex
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

#---------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------

# Output value definitions

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}
