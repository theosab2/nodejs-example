terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
  backend "azurerm" {
  }

}

provider "azurerm" {
  features {

  }
}

resource "azurerm_postgresql_server" "pg-srv" {
  name                = "postgresql-server-tsabri"
  location            = data.azurerm_resource_group.rg-maalsi.location
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = data.azurerm_key_vault_secret.pg-login.value
  administrator_login_password = data.azurerm_key_vault_secret.pg-password.value
  version                      = "9.5"
  ssl_enforcement_enabled      = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

}

resource "azurerm_service_plan" "app-plan" {
  name                = "plan-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  location            = data.azurerm_resource_group.rg-maalsi.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_postgresql_firewall_rule" "pg-srv" {
  name                = "firewall"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  server_name         = azurerm_postgresql_server.pg-srv.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "web-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  location            = azurerm_service_plan.app-plan.location
  service_plan_id     = azurerm_service_plan.app-plan.id

  site_config {
    application_stack {
      node_version = "16-lts"
    }
  }

  app_settings = {
    PORT= var.PORT
    DB_HOST= data.azurerm_key_vault_secret.db-host.value
    DB_USERNAME= "${data.azurerm_key_vault_secret.db-username.value}@${azurerm_postgresql_server.pg-srv.name}"
    DB_PASSWORD= data.azurerm_key_vault_secret.db-password.value
    DB_DATABASE= "postgres"
    DB_DAILECT= var.DB_DAILECT
    DB_PORT= var.DB_PORT
    ACCESS_TOKEN_SECRET = data.azurerm_key_vault_secret.access-token-secret.value
    REFRESH_TOKEN_SECRET = data.azurerm_key_vault_secret.access-token-secret.value
    ACCESS_TOKEN_EXPIRY = var.ACCESS_TOKEN_EXPIRY
    REFRESH_TOKEN_EXPIRY = var.REFRESH_TOKEN_EXPIRY
    REFRESH_TOKEN_COOKIE_NAME = var.REFRESH_TOKEN_COOKIE_NAME
  }
}

resource "azurerm_container_group" "rabbitmq" {
  name                = "aci-pgadmin-${var.project_name}${var.environment_suffix}"
  location            = data.azurerm_resource_group.rg-maalsi.location
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  dns_name_label      = "aci-pgadmin-${var.project_name}${var.environment_suffix}"
  os_type             = "Linux"

  container {
    name   = "pgadmin"
    image  = "dpage/pgadmin4"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "PGADMIN_DEFAULT_EMAIL" = data.azurerm_key_vault_secret.pgadmin-mail.value
      "PGADMIN_DEFAULT_PASS" = data.azurerm_key_vault_secret.pgadmin-password.value
    }
  }
}