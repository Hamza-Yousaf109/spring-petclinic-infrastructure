variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "Expected AWS account ID"
  type        = string
}

variable "cluster_name" {
  description = "Existing EKS cluster name"
  type        = string
}

variable "repository_url" {
  description = "GitOps repository URL"
  type        = string
}

variable "application_path_pattern" {
  description = "Path of the application Helm chart in the GitOps repository"
  type        = string
}