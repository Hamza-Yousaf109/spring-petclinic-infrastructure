variable "description" {
  description = "Description to use only after the existing KMS key is identified."
  type        = string
  default     = "Spring PetClinic EKS secrets encryption"
}

variable "enable_key_rotation" {
  description = "Whether automatic KMS key rotation is enabled."
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "KMS key deletion waiting period; this module does not schedule deletion."
  type        = number
  default     = 7
}

variable "key_alias" {
  description = "KMS alias for the EKS secrets encryption key."
  type        = string
}

variable "project_name" {
  description = "Project tag value."
  type        = string
  default     = "spring-petclinic"
}

variable "environment" {
  description = "Environment tag value."
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Additional tags to apply after the existing KMS key is inspected."
  type        = map(string)
  default     = {}
}