variable "namespace" {
  description = "Datadog namespace from the supplied platform description."
  type        = string
  default     = "datadog"
}

variable "chart_version" {
  description = "Datadog Helm chart version from the supplied platform description."
  type        = string
  default     = "3.152.0"
}

variable "chart_repository" {
  description = "Official Datadog Helm chart repository."
  type        = string
  default     = "https://helm.datadoghq.com"
}

variable "api_key_secret_name" {
  description = "Name of a pre-created Kubernetes Secret containing the Datadog API key."
  type        = string
}

variable "site" {
  description = "Datadog site hostname."
  type        = string
  default     = "datadoghq.com"
}

variable "collect_container_logs" {
  description = "Whether the Datadog Agent collects container logs; confirm current settings before enabling."
  type        = bool
  default     = false
}
variable "datadog_api_key" {
  description = "Datadog API key."
  type        = string
  sensitive   = true
}