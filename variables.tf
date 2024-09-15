variable "allocated_storage" {
  description = "The amount of allocated storage."
  type = number
  default = 20
}
variable "storage_type" {
  description = "type of the storage"
  type = string
  default = "io2"
}
variable "engine" {
  description = "The database engine"
  type = string
  default = "mysql"
}
variable "engine_version" {
  description = "The engine version"
  default = "8.0.32"
  type = string
}
variable "instance_class" {
  description = "The RDS instance class"
  default = "db.t3.micro"
  type = string
}
variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  default = "default.mysql8.0"
  type = string
}
variable "username" {
  description = "Username for the master DB user."
  default = "databaseteste"
  type = string
}
variable "password" {
  description = "password of the database"
  default = "password"
  type = string
}
variable "skip_final_snapshot" {
  description = "skip snapshot"
  default = "true"
  type = string
}
variable "multi_az" {
  description = "projeto multi_az"
  default = "false"
  type = string
}
variable "db_name"{
  description = "projeto multi_az"
  default = "burguer51"
  type = string
}
variable "db_user_name"{
  description = "projeto multi_az"
  default = "root"
  type = string
}
variable "db_password_name"{
  description = "projeto multi_az"
  default = "rootrootroot"
  type = string
}
variable "identifier" {
  description = "The name of the RDS instance"
  default = "terraform-database-test"
  type = string
}
variable "port" {
  description = "The port on which the DB accepts connections"
  default = "3306"
  type = number
}
variable "name" {
  description = "The database name"
  default = "Mysqldatabase"
  type = string
}