variable "environment" {
    type = string
}

variable "instance_class" {
  type    = string
  default = "db.r6g.large"
}

variable "master_username" {
  type    = string
  default = "dbadmin"
}

variable "master_password" {
  type      = string
  default   = "supersecretpassword" # in a real world sceaniro this would be passed through secrets manager
  sensitive = true
}