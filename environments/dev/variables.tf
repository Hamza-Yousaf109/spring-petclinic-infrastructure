# variable "environment" {
#   description = "Deployment environment name."
#   type        = string
# }

# variable "cluster_name" {
#   description = "Existing EKS cluster name."
#   type        = string
# }

# variable "kubernetes_version" {
#   description = "Kubernetes version used by the existing EKS cluster."
#   type        = string
# }

# variable "eks_public_access_cidrs" {
#   description = "Approved IPv4 CIDRs allowed to reach the public EKS endpoint."
#   type        = list(string)
# }

# variable "eks_cluster_admin_principal_arns" {
#   description = "Explicit IAM role ARNs granted EKS cluster-admin permissions."
#   type        = set(string)
# }
variable "datadog_api_key_secret_name" {
  description = "Pre-created Kubernetes Secret in the Datadog namespace containing the API key."
  type        = string
  default     = "datadog-api-key"
}

variable "collect_container_logs" {
  description = "Enable Datadog container log collection after reviewing ingestion and billing."
  type        = bool
  default     = true
}

variable "enable_argocd" {
  description = "Install Argo CD in the existing EKS cluster."
  type        = bool
  default     = true
}

variable "enable_datadog" {
  description = "Install Datadog in the existing EKS cluster."
  type        = bool
  default     = true
}
# variable "aws_region" {
#   description = "AWS region containing the EKS cluster."
#   type        = string
#   default     = "ap-south-1"
# }

# variable "aws_account_id" {
#   description = "Expected AWS account ID; the provider rejects other accounts."
#   type        = string
#   default     = "992382771174"
# }

variable "application_path_pattern" {
  description = "Application manifest path verified against the external GitOps repository."
  type        = string
  default     = "charts/petclinic"

}
variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Existing EKS cluster name."
  type        = string
  default     = "petclinic"
}

variable "kubernetes_version" {
  description = "Kubernetes version used by the existing EKS cluster."
  type        = string
  default     = "1.33"
}

variable "eks_public_access_cidrs" {
  description = "Approved IPv4 CIDRs allowed to reach the public EKS endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_admin_principal_arns" {
  description = "Explicit IAM principals granted EKS cluster-admin permissions."
  type        = set(string)
  default = [
    "arn:aws:iam::992382771174:user/hamza"
  ]
}

variable "aws_region" {
  description = "AWS region containing the EKS cluster."
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "Expected AWS account ID; the provider rejects other accounts."
  type        = string
  default     = "992382771174"
}
variable "datadog_api_key" {
  description = "Datadog API key provided at Terraform runtime."
  type        = string
  sensitive   = true
}
variable "repository_url" {
  description = "External GitOps repository URL."
  type        = string
}