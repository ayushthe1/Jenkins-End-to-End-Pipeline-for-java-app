
resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_sg_name
  description = "Enable the Port 22(SSH) & Port 80(http) & Port 443 (https) & 8080"
  vpc_id      = aws_vpc.dev_proj_1_vpc_us_east_1.id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTPS request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    description = "Allow 8080 port to access jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  ingress {
    description = "Allow 9000 port to access jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
  }

  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0 // any port
    to_port     = 0 // any port
    protocol    = "-1" // any protocol
    cidr_blocks = ["0.0.0.0/0"] // outbound traffic to all destination allowed
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80) and HTTPS(443) and 8080 and 9000"
  }
}