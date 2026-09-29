variable "name" {
  description = "Name prefix for the networking resources."
  type        = string
  default     = "petclinic"
}

variable "environment" {
  description = "Environment tag for the networking resources."
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR from the supplied network design."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones from the supplied network design."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs from the supplied network design."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs from the supplied network design."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "cluster_name" {
  description = "EKS cluster name used for subnet discovery tags."
  type        = string
  default     = "petclinic"
}

variable "tags" {
  description = "Additional tags to apply after existing tags are inspected."
  type        = map(string)
  default     = {}
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway for all private subnets; this has cross-AZ dependency and traffic-cost tradeoffs."
  type        = bool
  default     = true
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways; the supplied design uses one shared NAT Gateway."
  type        = number
  default     = 1

  validation {
    condition     = var.single_nat_gateway ? var.nat_gateway_count == 1 : var.nat_gateway_count == length(var.availability_zones)
    error_message = "Use exactly one NAT Gateway when single_nat_gateway is true, otherwise use one per Availability Zone."
  }
}