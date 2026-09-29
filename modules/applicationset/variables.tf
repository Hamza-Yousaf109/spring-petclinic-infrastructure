variable "namespace" {
  description = "Namespace where Argo CD is installed."
  type        = string
  default     = "argocd"
}

variable "repository_url" {
  description = "External GitOps repository URL."
  type        = string
}

variable "git_revision" {
  description = "Git revision tracked by the ApplicationSet."
  type        = string
  default     = "HEAD"
}

variable "application_path_pattern" {
  description = "Verified application manifest path pattern in the external repository."
  type        = string
}

variable "application_environments" {
  description = "Environment names generated as Argo CD Applications."
  type        = set(string)
  default     = ["dev", "staging", "prod"]
}

variable "destination_server" {
  description = "Kubernetes API server URL targeted by generated Applications."
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "project" {
  description = "Argo CD project used for generated Applications."
  type        = string
  default     = "default"
}