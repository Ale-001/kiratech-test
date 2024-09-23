output "manager_ip" {
  value = aws_instance.manager[0].public_ip
}

output "workers_ip" {
  value = aws_instance.workers[*].public_ip
}
