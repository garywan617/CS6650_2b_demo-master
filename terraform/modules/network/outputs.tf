###########################
# Outputs
###########################
output "private_subnet_ids" {
  description = "IDs of the private subnets for ECS"
  value       = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "public_subnet_ids" {
  description = "IDs of the public subnets for ALB"
  value       = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  description = "Security group ID for ECS"
  value       = aws_security_group.this.id
}
