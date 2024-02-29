terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "app-sindhu"
  location = "CentralIndia"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  
  name               = "appserviceplan"
  location           = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "mywebapp" {
  name                   = "mywebapp00678"
  location              = azurerm_resource_group.RG.location
  resource_group_name    = azurerm_resource_group.RG.name
  app_service_plan_id   = azurerm_app_service_plan.appserviceplan.id

  site_config {
    dotnet_framework_version = "v6.0"
  }


  connection_string {
    name  = "Database"
    type  = "MySQL"
    value = "Server=tcp:${var.mysql_server_fqdn};Database=${var.mysql_database_name}"
  }
}

resource "azurerm_mysql_server" "mysql_db" {
  name                  = "sindhu-server"
  location              = azurerm_resource_group.RG.location
  resource_group_name    = azurerm_resource_group.RG.name
  version               = "8.0"

  
  administrator_login    = var.mysql_server_admin_login
  administrator_login_password = var.mysql_server_admin_password
  public_network_access_enabled = true
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"


  sku_name = "B_Gen5_1"
}

resource "azurerm_sql_database" "my_app_database" {
  name                  = var.mysql_database_name
  location              = azurerm_resource_group.RG.location
  resource_group_name    = azurerm_resource_group.RG.name
  server_name           = azurerm_mysql_server.mysql_db.name
  

  # Example: Enable read scaling
  read_scale = true
  
}
resource "azurerm_mysql_firewall_rule" "mysql"{
     name = "mysqlfirewall"
    resource_group_name    = azurerm_resource_group.RG.name
    server_name           = azurerm_mysql_server.mysql_db.name
    start_ip_address =  "0.0.0.0"
    end_ip_address = "0.0.0.0"

}
