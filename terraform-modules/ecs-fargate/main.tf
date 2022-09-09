terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.0.0"
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
      terraform_stack_desc    = "Example DynamoDB Module"
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
resource "random_id" "releasehub" {
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

locals {
  random_releasehub_id = random_id.releasehub.hex
  release_unique_prefix_slashed = "/releasehub/${var.RELEASE_APP_NAME}/${var.RELEASE_BRANCH_NAME}/${var.RELEASE_ENV_ID}"
  release_unique_prefix_dashed = "releasehub-${var.RELEASE_APP_NAME}-${var.RELEASE_BRANCH_NAME}-${var.RELEASE_ENV_ID}"
  release_short_prefix = "releasehub-${var.RELEASE_ENV_ID}"

}

#---------------------------------------------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



module "alb" {
  source  = "umotif-public/alb/aws"
  version = "~> 2.0"


  name_prefix        = local.random_releasehub_id
  load_balancer_type = "application"
  internal           = false
  vpc_id             = data.aws_vpc.default.id
  subnets            = data.aws_subnets.all.ids
}


resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = module.alb.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "task_ingress_80" {
  security_group_id        = module.ecs-fargate.service_sg_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = module.alb.security_group_id
}

resource "aws_ecs_cluster" "cluster" {
  name = local.random_releasehub_id

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}



resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}


module "ecs-fargate" {
  source = "umotif-public/ecs-fargate/aws"
  version = "~> 6.1.0"

  name_prefix        = local.random_releasehub_id
  vpc_id             = data.aws_vpc.default.id
  private_subnet_ids = data.aws_subnets.all.ids
  cluster_id         = aws_ecs_cluster.cluster.id

  task_container_image   = "marcincuber/2048-game:latest"
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 80
  task_container_assign_public_ip = true

  load_balanced =  true
  
  target_groups = [
    {
      target_group_name =  "${local.release_short_prefix}"
      container_port    = 80
    }
  ]

  health_check = {
    port = "traffic-port"
    path = "/"
  }
}

#---------------------------------------------------------------------------------------

# We can also write outputs to a place like AWS Parameter Store for visibility or integration with other services: 
resource "aws_ssm_parameter" "alb_dns_name" {
  name  = "${local.release_unique_prefix_slashed}/alb_dns_name"
  type  = "String"
  value = module.alb.dns_name
}

# Or use native TF outputs:
output "alb_dns_name" {
  value = module.alb.dns_name
}
