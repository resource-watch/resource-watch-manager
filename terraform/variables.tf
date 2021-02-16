variable "environment" {
  type = string
}

variable "user_name" {
  type = string
  default = "resouce-watch-manager"
  description = "Name of database user"
}

variable "password" {
  type = string
  description = "Password for database user"
}

variable "database" {
  type = string
  default = "resource-watch-manager"
  description = "Database name"
}