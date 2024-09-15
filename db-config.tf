provider "aws" {
  region     = "us-east-1" # Defina a região AWS desejada
  access_key = secrets.ACCESS_KEY_AWS
  secret_key = secrets.SECRET_KEY_AWS
  token      = secrets.TOKEN_AWS
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage    # Tamanho do armazenamento em GB
  storage_type         = var.storage_type         # Tipo de armazenamento (gp2 é SSD de propósito geral)
  engine               = var.engine               # Engine do banco de dados
  engine_version       = var.engine_version       # Versão do MySQL
  instance_class       = var.instance_class       # Tipo de instância
  db_name              = var.db_name              # Nome do banco de dados
  username             = var.db_user_name         # Nome de usuário do administrador
  password             = var.db_password_name     # Senha do administrador
  parameter_group_name = var.parameter_group_name # Grupo de parâmetros
  skip_final_snapshot  = var.skip_final_snapshot  # Se verdadeiro, não cria um snapshot final ao excluir a instância

  # Configurações de rede
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  # Configurações adicionais
  backup_retention_period = 7            # Período de retenção de backup em dias
  multi_az                = false # Se deve ser configurado em múltiplas zonas de disponibilidade
  publicly_accessible     = true         # Se a instância deve ser acessível publicamente
}

#1.Cria VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "My51BurguerVPC"
  }
}
#Cria 2 subnets publicas de exemplo
resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
}
resource "aws_subnet" "PublicSubnetB" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"
}

#4 : create IGW
resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myvpc.id
}

#5 : route Tables for public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIgw.id
  }
}

#6 : route table association public subnet 
resource "aws_route_table_association" "PublicRTAssociationA" {
  subnet_id      = aws_subnet.PublicSubnetA.id
  route_table_id = aws_route_table.PublicRT.id
}

#6 : route table association public subnet 
resource "aws_route_table_association" "PublicRTAssociationB" {
  subnet_id      = aws_subnet.PublicSubnetB.id
  route_table_id = aws_route_table.PublicRT.id
}

#associa subnet no grupo de subnet que serao utilizadas
resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.PublicSubnetA.id, aws_subnet.PublicSubnetB.id]

  tags = {
    Name = "my-db-subnet-group"
  }
}

resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.myvpc.id
  name_prefix = "my-db-sg-"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite acesso de qualquer lugar, ajuste conforme necessário
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


//usar o secret manager da aws?