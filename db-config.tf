resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage    # Tamanho do armazenamento em GB
  storage_type         = var.storage_type         # Tipo de armazenamento (gp2 é SSD de propósito geral)
  engine               = var.engine               # Engine do banco de dados
  engine_version       = var.engine_version       # Versão do MySQL
  instance_class       = var.instance_class       # Tipo de instância
  db_name              = var.db_name              # Nome do banco de dados
  username             = var.db_user_name         # Nome de usuário do administrador
  password             = var.db_password_name     # Senha do administrador
  skip_final_snapshot  = var.skip_final_snapshot  # Se verdadeiro, não cria um snapshot final ao excluir a instância

  # Configurações de rede
  vpc_security_group_ids = ["${aws_security_group.securityGroupDB.id}"]
  db_subnet_group_name   = aws_db_subnet_group.subnetGroupDB.name

  # Configurações adicionais
  backup_retention_period = 7            # Período de retenção de backup em dias
  multi_az                = var.multi_az # Se deve ser configurado em múltiplas zonas de disponibilidade
  publicly_accessible     = true         # Se a instância deve ser acessível publicamente
}

#Cria 1 subnets para DB
resource "aws_subnet" "privateSubnetA" {
  vpc_id            = data.aws_vpc.fiap51Vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.3.0/24"
}
resource "aws_subnet" "privateSubnetB" {
  vpc_id            = data.aws_vpc.fiap51Vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.4.0/24"
}

#associa subnet no grupo de subnet que serao utilizadas
resource "aws_db_subnet_group" "subnetGroupDB" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.privateSubnetA.id, aws_subnet.privateSubnetB.id]

  tags = {
    Name = "my-db-subnet-group"
  }
}

resource "aws_security_group" "securityGroupDB" {
  vpc_id      = data.aws_vpc.fiap51Vpc.id
  name_prefix = "my-db-sg-"

  ingress {
    from_port   = 5432
    to_port     = 5432
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


data "aws_vpc" "fiap51Vpc" {
  filter {
    name   = "tag:Name"
    values = ["My51BurguerVPC"]
  }
}



#Permite acesso local
data "aws_internet_gateway" "fiap51Igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.fiap51Vpc.id]
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = data.aws_vpc.fiap51Vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.fiap51Igw.id
  }
}
#6 : route table association  
resource "aws_route_table_association" "PublicRTAssociationA" {
  subnet_id      = aws_subnet.privateSubnetA.id
  route_table_id = aws_route_table.PublicRT.id
}
#6 : route table association
resource "aws_route_table_association" "PublicRTAssociationB" {
  subnet_id      = aws_subnet.privateSubnetB.id
  route_table_id = aws_route_table.PublicRT.id
}


//usar o secret manager da aws?