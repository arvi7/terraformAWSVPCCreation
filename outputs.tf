# Output vpc_id which contain the id of VPC created.
output "vpc_id" {
  value = aws_vpc.webapp_vpc.id
}