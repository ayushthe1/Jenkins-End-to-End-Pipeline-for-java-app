resource "aws_vpc" "dev_proj_1_vpc_us_east_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "dev_public_subnet" {
  
  vpc_id            = aws_vpc.dev_proj_1_vpc_us_east_1.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.tag_name
  }
}

resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_ec2_terraform" // name of an existing SSH key pair that will be associated with an EC2 instance when it's launched
  subnet_id                   = aws_subnet.dev_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  // Script to be executed when the EC2 instance is launched
  user_data = templatefile("jenkins_and_sonarcube-installer.sh", {})

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"
  public_key = var.public_key
}

resource "aws_internet_gateway" "dev_proj_1_public_internet_gateway" {
  vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id
  tags = {
    Name = "dev-proj-1-igw"
  }
}

resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id
  route {
    // all egress traffic from the subnet should be routed to igw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_proj_1_public_internet_gateway.id
  }
  tags = {
    Name = "dev-proj-1-public-rt"
  }
}

// Attaching the public subnets to the route table which is connected to igw
resource "aws_route_table_association" "dev_rt_subnet_association" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_rt.id
}