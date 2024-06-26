provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "main_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "db" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "hiberus-challenge" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.14" 
  instance_class       = "db.t3.micro"
  identifier           = "challenge-hiberus"
  username             = "dbuser"
  password             = "321654hiberus"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.main_a.id, aws_subnet.main_b.id]
}

resource "aws_ecr_repository" "app_repo" {
  name = "hiberus-repository"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02aead0a55359d6ec"  # Reemplazar con una AMI válida para us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main_a.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = file("${path.module}/../ec2/user-data.sh")

  tags = {
    Name = "AppServer"
  }
}

