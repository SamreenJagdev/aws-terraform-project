###################RESOURCE FILE######################
#Define VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

#Define Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" = var.subnet_name
  }
}

#Define Internet Gateway
resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    "name" = "main_ig"
  }
}

#Define Route Table
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }
  // route = []

  tags = {
    Name = "main_rt"
  }
}

#Define Route
/* resource "aws_route" "route" {
  route_table_id         = aws_route_table.main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_ig.id
} */

#Define network interface
/* resource "aws_network_interface" "server_network" {
  subnet_id   = aws_subnet.main_subnet.id
  private_ips = ["10.0.1.10"]

  tags = {
    name = "primary_network_interface"
  }
} */

#Define Security group
resource "aws_security_group" "allow_sg" {
  name        = "allow_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sg"
  }
}

#Define Route Table with Subnet Association
resource "aws_route_table_association" "route_subnet_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_key_pair" "ssh-key-ansible" {
  key_name   = "ssh-key-ansible"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDexwI/FYYfmJrvXLBj73fDz0krLlBvzpe/lDJhNuHmrE7a/18APCSNih8V3T4cqNjt9C4R1gQUwIg4d3bMlzVA2bhCjJSLDOW+II6VIlr6e3FnAvVCyWElDqPmn4EbEgJklCfVjJBP+pw7nhoq41vgI7tUVCHOTUlJ1n1mNEScwEk+qUqL9y6TQPdIj7UbVZ8oVXxchnXRIcvnIZ9rmOELPr5/l3mRc1nl2Pg7LShsz7MQQLFQRAfHzsHxpEK6ipN335/azwjWXOuO9sBZqgtoP0UCpHfqGvaFirxJ4nglIkA3i7vJPUV8wkSe8QxP07HGswqFB53gll1VSqt+chyniyF0OZKWd5VtxDF/MCaqDkBFLYnC1htOceKCqYgLYu23o42w4/vJV4o279j4E/aCxBX/rw1x4v27mbMEJlMQvsd0lamXGV5CbcvzXKwo1nunteNulrzx3he1I17heUWBaHbi5GLahP90uQiBiB/Q2HyQVng0MUwHWQSi/jXc4Lc= jasme@DESKTOP-E7E9B8B"
}

#Create EC2 instance-1 
resource "aws_instance" "web-server-1" {
  ami                         = "ami-0022f774911c1d690"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_sg.id]
  key_name                    = "ssh-key-ansible"
  //subnet_id     = data.aws_subnet.selected.id
  tags = {
    Name = "Ansible-Linux-Server"
  }
}


#Create EC2 instance-2
resource "aws_instance" "web-server-2" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  // subnet_id=aws_subnet.main_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_sg.id]
  key_name                    = "ssh-key-ansible"
  tags = {
    Name = "Ansible-Linux-Client"
  }
}

