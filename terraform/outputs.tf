output "instance_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.hiberus-challenge.endpoint
}
