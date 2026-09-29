variable "namespace" {
  description = "Argo CD namespace from the supplied platform description."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version from the supplied platform description."
  type        = string
  default     = "8.5.7"
}

variable "chart_repository" {
  description = "Official Argo Helm chart repository."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}
