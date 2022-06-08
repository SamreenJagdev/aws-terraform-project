#Ouput of EC2 instance - Web-Server-1

output "instance_id_1"{
    description = "ID of the EC2 Instance"
    value = aws_instance.web-server-1.id
}

output "instance_PrivateDnsName_1" {
    description = "EC2 Private DNS"
    value = aws_instance.web-server-1.private_dns
}

output "instance_publicIp_1" {
  description = "Public IP of EC2 Instance"
  value = aws_instance.web-server-1.public_ip
}

output "aws_public_dns_1" {
  description = "Public DNS of EC2 instance"
  value = aws_instance.web-server-1.public_dns
}

#Ouput of EC2 instance - Web-Server-2

output "instance_id_2"{
    description = "ID of the EC2 Instance"
    value = aws_instance.web-server-2.id
}

output "instance_PrivateDnsName_2" {
    description = "EC2 Private DNS"
    value = aws_instance.web-server-2.private_dns
}

output "instance_publicIp_2" {
  description = "Public IP of EC2 Instance"
  value = aws_instance.web-server-2.public_ip
}

output "aws_public_dns_2" {
  description = "Public DNS of EC2 instance"
  value = aws_instance.web-server-2.public_dns
}

