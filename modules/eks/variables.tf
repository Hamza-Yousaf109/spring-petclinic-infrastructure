variable "cluster_name" {
  description = "Existing EKS cluster name."
  type        = string
  default     = "petclinic"
}

variable "environment" {
  description = "Environment tag value."
  type        = string
  default     = "production"
}

variable "kubernetes_version" {
  description = "Kubernetes version from the supplied cluster description."
  type        = string
  default     = "1.33"
}

variable "enable_auto_mode" {
  description = "Whether EKS Auto Mode is enabled."
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "EKS Auto Mode node pool names from the supplied description."
  type        = set(string)
  default     = ["general-purpose", "system"]
}

variable "endpoint_public_access" {
  description = "Whether the EKS public API endpoint is enabled."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS private API endpoint is enabled."
  type        = bool
  default     = true
}

variable "control_plane_log_types" {
  description = "EKS control-plane log types from the supplied description."
  type        = set(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt EKS Kubernetes secrets."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS Auto Mode nodes."
  type        = string
}

variable "public_access_cidrs" {
  description = "Approved IPv4 CIDRs allowed to reach the public EKS API endpoint."
  type        = list(string)

  validation {
    condition     = !var.endpoint_public_access || length(var.public_access_cidrs) > 0
    error_message = "When the public EKS endpoint is enabled, public_access_cidrs must contain explicit approved CIDRs."
  }
}

variable "cluster_admin_principal_arns" {
  description = "Explicit IAM role ARNs to receive EKS cluster-admin access."
  type        = set(string)

  validation {
    condition     = length(var.cluster_admin_principal_arns) > 0
    error_message = "At least one approved IAM role ARN must be supplied for EKS administrator access."
  }
}

variable "tags" {
  description = "Additional EKS cluster tags."
  type        = map(string)
  default     = {}
}

variable "cluster_log_retention_days" {
  description = "CloudWatch retention period for EKS control-plane logs."
  type        = number
  default     = 90
}