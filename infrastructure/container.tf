resource "azurerm_container_group" "main" {
  name                = "container-group"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  #ip_address_type     = "Private"
  #dns_name_label      = "lockyz" #This only works if ip_address_type = Public
  os_type             = "Linux"

  container {
    name   = "container-name"
    image  = "servian/techchallengeapp:latest"
    cpu    = "2.0"
    memory = "2.0"
    commands = [
        "./TechChallengeApp serve"

    ]

    ports {
      port     = 3000
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
resource "azurerm_postgresql_server" "main" {
  name                = "db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "main" {
  name                = "db"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}