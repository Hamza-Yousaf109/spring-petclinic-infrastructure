variable "cluster_name" {
  description = "Existing EKS cluster name supported by these IAM roles."
  type        = string
  default     = "petclinic"
}

variable "environment" {
  description = "Environment tag for IAM resources."
  type        = string
  default     = "production"
}

variable "role_purposes" {
  description = "Role responsibilities from the supplied infrastructure description."
  type        = set(string)
  default     = ["eks-control-plane", "eks-auto-mode", "worker-node"]
}

variable "tags" {
  description = "Additional tags to apply after existing IAM resources are inspected."
  type        = map(string)
  default     = {}
}