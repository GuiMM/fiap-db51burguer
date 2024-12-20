variable "allocated_storage" {
  description = "The amount of allocated storage."
  type        = number
  default     = 20
}
variable "storage_type" {
  description = "type of the storage"
  type        = string
  default     = "gp3"
}
variable "engine" {
  description = "The database engine"
  type        = string
  default     = "postgres"
}
variable "engine_version" {
  description = "The engine version"
  default     = "16.3"
  type        = string
}
variable "instance_class" {
  description = "The RDS instance class"
  default     = "db.t3.micro"
  type        = string
}
variable "skip_final_snapshot" {
  description = "skip snapshot"
  default     = "true"
  type        = string
}
variable "multi_az" {
  description = "projeto multi_az"
  default     = "false"
  type        = string
}
variable "db_name_client" {
  description = "create db_name"
  type        = string
}
variable "db_user_name_client" {
  description = "create db_user_name"
  type        = string
}
variable "db_password_client" {
  description = "create db_password"
  type        = string
}
variable "db_name_order" {
  description = "create db_name"
  type        = string
}
variable "db_user_name_order" {
  description = "create db_user_name"
  type        = string
}
variable "db_password_order" {
  description = "create db_password"
  type        = string
}
variable "identifier_bd_client" {
  description = "The name of the RDS instance"
  default     = "database-51burguer-client"
  type        = string
}
variable "identifier_bd_order" {
  description = "The name of the RDS instance"
  default     = "database-51burguer-order"
  type        = string
}
