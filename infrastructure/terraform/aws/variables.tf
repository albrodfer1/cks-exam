# variables.tf
variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "eu-west-1" # Set to London region by default
}

variable "allowed_ip_range" {
  description = "Allowed IP range for firewall rules"
  type        = string
}