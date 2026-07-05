resource "aws_vpc" "k8_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
  
tags = local.common_tags

}

resource "aws_internet_gateway" "k8" {
  vpc_id = aws_vpc.k8_vpc.id                     # vpc accostaions

  tags = local.igw_final_tags
}

resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.k8_vpc.id
    cidr_block              = var.public_cidr
    availability_zone       = var.availability_zone
    map_public_ip_on_launch = true
    
tags = {
    Name = "k8_public-subnet"
  }
} 

resource "aws_route_table" "k8" {
  vpc_id = aws_vpc.k8_vpc.id
}

# ✅ Route to Internet
resource "aws_route" "route" {
  route_table_id         = aws_route_table.k8.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.k8.id

}

# ✅ Associate Route Table
resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.k8.id
}

# ✅ Security Group (ONLY SSH)
resource "aws_security_group" "sg" {
  name   = "ssh-only-sg"
  vpc_id = aws_vpc.k8_vpc.id

  ingress {
    description = "SSH Access"
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
}

# ✅ EC2 (Docker + /var extend)
resource "aws_instance" "k8s_ec2" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 50
  }
  tags = merge(
    {
        Name = "${var.project}-${var.environment}-k8s"
    },
    local.common_tags
  )
}