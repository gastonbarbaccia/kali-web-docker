output "instance_ips" {
  description = "Lista de direcciones IP públicas de las instancias"
  value       = aws_instance.ec2_instances[*].public_ip
}
