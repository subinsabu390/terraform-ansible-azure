data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
    name = var.key_vault_name
    sku_name = "standard"
    tenant_id = data.azurerm_client_config.current.tenant_id
    resource_group_name = var.rg_name
    location = var.rg_location

    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "List",
    ]
  }
}