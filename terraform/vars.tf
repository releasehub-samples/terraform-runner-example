variable "RELEASE_ENV_ID" {
  type        = string
  description = "Unique identifier for the Release environment"
}

variable "LAMBDA_REGION" {
  type        = string
  description = "Region to which we will deploy our Lambda function"
}