terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region = "${var.RELEASE_CLUSTER_REGION}"
   default_tags {
   tags = {
     release_env_id = "${var.RELEASE_ENV_ID}"
   }
 }
}
