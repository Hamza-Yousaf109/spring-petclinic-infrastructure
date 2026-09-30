data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Project     = "spring-petclinic"
    Environment = var.environment
  }
}

check "expected_aws_account" {
  assert {
    condition = (
      data.aws_caller_identity.current.account_id == var.aws_account_id
    )

    error_message = "The active AWS credentials are not for the configured aws_account_id."
  }
}

module "networking" {
  source = "../../../modules/networking"

  name               = var.cluster_name
  cluster_name       = var.cluster_name
  environment        = var.environment
  tags               = local.common_tags
  single_nat_gateway = true
  nat_gateway_count  = 1
}

module "iam" {
  source = "../../../modules/iam"

  cluster_name = var.cluster_name
  environment  = var.environment
  tags         = local.common_tags
}

module "kms" {
  source = "../../../modules/kms"

  description             = "KMS key for ${var.cluster_name} EKS secrets encryption"
  key_alias               = "alias/${var.cluster_name}-eks"
  project_name            = "spring-petclinic"
  environment             = var.environment
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags                    = local.common_tags
}

module "eks" {
  source = "../../../modules/eks"

  cluster_name       = var.cluster_name
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  enable_auto_mode   = true
  node_pools         = ["general-purpose", "system"]

  endpoint_public_access  = true
  endpoint_private_access = true
  public_access_cidrs     = var.eks_public_access_cidrs

  control_plane_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  private_subnet_ids = module.networking.configuration.private_subnet_ids
  cluster_role_arn   = module.iam.configuration.cluster_role_arn
  node_role_arn      = module.iam.configuration.auto_mode_node_role_arn
  kms_key_arn        = module.kms.configuration

  cluster_admin_principal_arns = var.eks_cluster_admin_principal_arns
  cluster_log_retention_days   = 90

  tags = local.common_tags
}