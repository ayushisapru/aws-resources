# for database

output "db_endpoint" {
  value = aws_db_instance.example.endpoint
}

output "db_name" {
  value = aws_db_instance.example.name
}
