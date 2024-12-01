resource "aws_db_instance" "fiap51BurguerRds1" {
  identifier           = var.identifier_bd_client
  allocated_storage    = var.allocated_storage    # Tamanho do armazenamento em GB
  storage_type         = var.storage_type         # Tipo de armazenamento (gp2 é SSD de propósito geral)
  engine               = var.engine               # Engine do banco de dados
  engine_version       = var.engine_version       # Versão do MySQL
  instance_class       = var.instance_class       # Tipo de instância
  db_name              = var.db_name_client              # Nome do banco de dados
  username             = var.db_user_name_client         # Nome de usuário do administrador
  password             = var.db_password_client     # Senha do administrador
  skip_final_snapshot  = var.skip_final_snapshot  # Se verdadeiro, não cria um snapshot final ao excluir a instância

  # Configurações de rede
  vpc_security_group_ids = ["${aws_security_group.securityGroupDB.id}"]
  db_subnet_group_name   = aws_db_subnet_group.subnetGroupDB.name

  # Configurações adicionais
  backup_retention_period = 7            # Período de retenção de backup em dias
  multi_az                = var.multi_az # Se deve ser configurado em múltiplas zonas de disponibilidade
  publicly_accessible     = true         # Se a instância deve ser acessível publicamente
}

resource "aws_db_instance" "fiap51BurguerRds2" {
  identifier           = var.identifier_bd_order
  allocated_storage    = var.allocated_storage    # Tamanho do armazenamento em GB
  storage_type         = var.storage_type         # Tipo de armazenamento (gp2 é SSD de propósito geral)
  engine               = var.engine               # Engine do banco de dados
  engine_version       = var.engine_version       # Versão do MySQL
  instance_class       = var.instance_class       # Tipo de instância
  db_name              = var.db_name_order              # Nome do banco de dados
  username             = var.db_user_name_order         # Nome de usuário do administrador
  password             = var.db_password_order     # Senha do administrador
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
resource "aws_subnet" "privateSubnetC" {
  vpc_id            = data.aws_vpc.fiap51Vpc.id
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "private-subnet-db-c"
  }
}
resource "aws_subnet" "privateSubnetD" {
  vpc_id            = data.aws_vpc.fiap51Vpc.id
  availability_zone = "us-east-1d"
  cidr_block        = "10.0.4.0/24"
  tags = {
    Name = "private-subnet-db-d"
  }
}

#associa subnet no grupo de subnet que serao utilizadas
resource "aws_db_subnet_group" "subnetGroupDB" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.privateSubnetC.id, aws_subnet.privateSubnetD.id]

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


resource "aws_route_table" "PrivateRT" {
  vpc_id = data.aws_vpc.fiap51Vpc.id
  
}

#6 : route table association  
resource "aws_route_table_association" "PrivateRTAssociationA" {
  subnet_id      = aws_subnet.privateSubnetC.id
  route_table_id = aws_route_table.PrivateRT.id
}

#6 : route table association
resource "aws_route_table_association" "PrivateRTAssociationB" {
  subnet_id      = aws_subnet.privateSubnetD.id
  route_table_id = aws_route_table.PrivateRT.id
}
