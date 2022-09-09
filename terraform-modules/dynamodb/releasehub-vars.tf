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
