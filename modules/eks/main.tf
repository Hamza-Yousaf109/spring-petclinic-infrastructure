locals {
  common_tags = merge(var.tags, {
    Project     = var.cluster_name
    Environment = var.environment
  })
}

resource "aws_eks_cluster" "petclinic" {
  name                          = var.cluster_name
  role_arn                      = var.cluster_role_arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode = "API"
  }

  enabled_cluster_log_types = var.control_plane_log_types

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.public_access_cidrs : null
  }

  compute_config {
    enabled       = var.enable_auto_mode
    node_role_arn = var.node_role_arn
    node_pools    = var.enable_auto_mode ? var.node_pools : []
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  tags = local.common_tags

  depends_on = [aws_cloudwatch_log_group.cluster]

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_days

  tags = local.common_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eks_access_entry" "cluster_admin" {
  for_each = var.cluster_admin_principal_arns

  cluster_name  = aws_eks_cluster.petclinic.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  for_each = var.cluster_admin_principal_arns

  cluster_name  = aws_eks_cluster.petclinic.name
  principal_arn = each.value
  policy_arn    = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.cluster_admin]
}

data "aws_partition" "current" {}