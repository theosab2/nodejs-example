data "azurerm_resource_group" "rg-maalsi" {
  name     = "rg-${var.project_name}"
}

data "azurerm_key_vault" "kv"{
  name = "kv-${var.project_name}-dev"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
}

data "azurerm_key_vault_secret" "pg-login"{
  name = "pg-login"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pg-password"{
  name = "pg-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "db-host"{
  name = "db-host"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "db-username"{
  name = "db-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "db-password"{
  name = "db-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "access-token-secret"{
  name = "access-token-secret"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pgadmin-mail"{
  name = "pgadmin-mail"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pgadmin-password"{
  name = "pgadmin-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}