variable "aws_region" {
  description = "The target AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_app_subnet_cidr" {
  description = "CIDR block for the private application subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_db_subnet_cidr" {
  description = "CIDR block for the isolated database subnet"
  type        = string
  default     = "10.0.20.0/24"
}

variable "availability_zone" {
  description = "Target availability zone"
  type        = string
  default     = "us-east-1a"
}
