variable "environment" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "db_endpoint" {
    type = string
}

variable "db_name" {
    type = string
}

variable "db_security_group_id" {
  type = list(string)
}
