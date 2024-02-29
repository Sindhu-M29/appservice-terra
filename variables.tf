variable "mysql_server_admin_login" {
    default= "sindhu"
  description = "enter the username"
  sensitive = true
}

variable "mysql_server_admin_password" {
  description = "enter your password"
  sensitive = true
}



variable "mysql_server_fqdn" {
    default= "sindhu-server"
  description = "Fully qualified domain name of the MySQL server"
}

variable "mysql_database_name" {
    default = "my_app_data"
  description = "Name of the MySQL database"
}
