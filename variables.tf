variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "ssh_cidr" {
  description = "CIDR allowed to access SSH"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "wp_admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
