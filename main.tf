resource "aws_security_group" "ec2_sg" {
  name        = "wordpress-ec2-sg-${var.environment}"
  description = "Allow HTTP and SSH inbound traffic"

  # SSH Access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    
  }

  # HTTP Access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound All Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wordpress-ec2-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 1. Searching for AMI Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Instance EC2
resource "aws_instance" "web" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro" # or t2.micro 
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Setting up form the start 
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx php8.1-fpm php-mysql
              systemctl enable --now nginx
              EOF

  tags = {
    Name        = "wordpress-ec2-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 3. Security Group for RDS (access ONLY from EC2)
resource "aws_security_group" "rds_sg" {
  name        = "wordpress-rds-sg-${var.environment}"
  description = "Allow MySQL access only from EC2"

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # Stack of Security Groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-rds-sg"
  }
}

# 4. Database AWS RDS MySQL
resource "aws_db_instance" "default" {
  allocated_storage      = 20
  max_allocated_storage  = 20
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               =  var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true 
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "wordpress-rds"
  }
}
