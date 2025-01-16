provider "aws" {
  region = "eu-west-1"  # Cambia a la región de tu preferencia
}

# Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Crear las subredes en dos zonas de disponibilidad
resource "aws_subnet" "subnet_a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.255.0/24"
  availability_zone       = "eu-west-1a"  # Zona de disponibilidad A
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.128.0/24"
  availability_zone       = "eu-west-1b"  # Zona de disponibilidad B
  map_public_ip_on_launch = true
}

# Crear el grupo de subredes para RDS, cubriendo dos zonas de disponibilidad
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

# Crear el grupo de seguridad para la instancia RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow access to RDS instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306  # Puerto de MySQL
    to_port     = 3306
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

# Crear la instancia RDS (por ejemplo, MySQL)
resource "aws_db_instance" "default" {
  identifier        = "rds-instance"
  allocated_storage = 20  # Espacio en disco
  storage_type      = "gp2"  # Tipo de almacenamiento
  engine            = "mysql"  # Motor de la base de datos
  engine_version    = "8.0"   # Versión de MySQL
  instance_class    = "db.t3.micro"  # Instancia económica (capa gratuita)

  username = "admin"  # Usuario administrador
  password = "password123"  # Contraseña (asegúrate de usar una contraseña segura)

  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true

  # Configuración de la VPC
  multi_az = false
  publicly_accessible = true
}
