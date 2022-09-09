#---------------------------------------------------------------------------------------
variable "RELEASE_ACCOUNT_ID" {
  type        = string
  description = "ReleaseHub account ID"
  default = "0000"
}

variable "RELEASE_APP_NAME" {
  type        = string
  description = "ReleaseHub Application Name"
  default = "localhost"
}

variable "RELEASE_ENV_ID" {
  type        = string
  description = "ReleaseHub Environment ID"
  default = "ted9999"
}

variable "RELEASE_BRANCH_NAME" {
  type        = string
  description = "Source control branch that this environment was created from"
  default = "local"
}

variable "RELEASE_BUILD_ID" {
  type        = string
  description = "ReleaseHub Build ID for the setup or update workflow causing this Terraform module to run"
  default = "local"
}

variable "RELEASE_CLOUD_PROVIDER" {
  type        = string
  description = "ReleaseHub platform of this environment (gcp or aws)"
  default = "aws"
}

variable "RELEASE_CLUSTER_REGION" {
  type        = string
  description = "ReleaseHub platform of this environment (gcp or aws)"
  default = "us-west-2"
}

variable "RELEASE_CONTEXT" {
  type        = string
  description = "Name of the Kubernetes (e.g. EKS or GKE) cluster this environment is pinned to run on"
  default = "localhost"
}

variable "RELEASE_DOMAIN" {
  type        = string
  description = "Unique identifier for the Release environment"
  default = "local.example"
}
