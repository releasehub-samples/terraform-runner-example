module "lambda_function" {
  #function_name                     = "terraform-runner-blog"
  source                            = "terraform-aws-modules/lambda/aws"
  description                       = "Demo function created with Terraform via ReleaseHub"
  handler                           = "index.handler"
  runtime                           = "nodejs14.x"
  source_path                       = "./lambda"
  policy_path                       = "/release/"
  role_path                         = "/release/"
  role_name                         = "lambda"
  cloudwatch_logs_retention_in_days = 30
}
