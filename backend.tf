//armazena arquivo tfstate no bucket para nao expor informações de recursos AWS
//devemos ja ter o bucket criado para armazenar o tftstate e nao ser destruido por um eventual terraform destroy
//Se rodando local, lembrar de mudar arquivo credentials
terraform {
  backend "s3" {
    bucket = "51burguer-rds-backend-tf"
    key = "fiap51Burguer/terraform.tfstate"
    region = "us-east-1"
   
  }
}