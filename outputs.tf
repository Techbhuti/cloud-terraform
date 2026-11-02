output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public load balancer subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "private_app_subnet_id" {
  description = "The ID of the private application compute subnet"
  value       = aws_subnet.private_app_subnet_1.id
}

output "private_db_subnet_id" {
  description = "The ID of the isolated database subnet"
  value       = aws_subnet.private_db_subnet_1.id
}

output "web_security_group_id" {
  description = "The ID of the web tier security group"
  value       = aws_security_group.web_sg.id
}
