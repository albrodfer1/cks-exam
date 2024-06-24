# variables.tf
variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
}

variable "allowed_ip_range" {
  description = "Allowed IP range for firewall rules"
  type        = string
}
