output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS MySQL instance"
  value       = aws_db_instance.default.endpoint
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.wordpress.port
}
