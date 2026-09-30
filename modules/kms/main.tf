locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}

resource "aws_kms_key" "eks" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

  tags = local.common_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "eks" {
  name          = var.key_alias
  target_key_id = aws_kms_key.eks.key_id
}