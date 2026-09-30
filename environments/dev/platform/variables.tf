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

variable "datadog_api_key_secret_name" {
  description = "Kubernetes secret name for Datadog API key"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "collect_container_logs" {
  description = "Enable Datadog container log collection"
  type        = bool
  default     = true
}