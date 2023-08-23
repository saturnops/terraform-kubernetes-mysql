data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "random_password" "mysqldb_root_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_custom_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_replication_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_exporter_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "azurerm_key_vault" "mysql-secret" {
  count                       = var.store_password_to_secret_manager ? 1 : 0
  name                        = format("%s-%s-%s", var.environment, var.name, "mysql")
  resource_group_name         = var.resource_group_name
  location                    = var.resource_group_location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
      "List",
    ]
    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
    ]
  }
}

resource "azurerm_key_vault_secret" "mysql-secret" {
  depends_on = [azurerm_key_vault.mysql-secret[0]]
  name       = format("%s-%s-%s", var.environment, var.name, "secret")
  value = var.mysqldb_custom_credentials_enabled ? jsonencode(
    {
      "root_user" : "${var.mysqldb_custom_credentials_config.root_user}",
      "root_password" : "${var.mysqldb_custom_credentials_config.root_password}",
      "custom_username" : "${var.mysqldb_custom_credentials_config.custom_username}",
      "custom_user_password" : "${var.mysqldb_custom_credentials_config.custom_user_password}",
      "replication_user" : "${var.mysqldb_custom_credentials_config.replication_user}",
      "replication_password" : "${var.mysqldb_custom_credentials_config.replication_password}",
      "exporter_user" : "${var.mysqldb_custom_credentials_config.exporter_user}",
      "exporter_password" : "${var.mysqldb_custom_credentials_config.exporter_password}"
    }) : jsonencode(
    {
      "root_user" : "root",
      "root_password" : "${random_password.mysqldb_root_password[0].result}",
      "custom_username" : "${var.custom_user_username}",
      "custom_user_password" : "${random_password.mysqldb_custom_user_password[0].result}",
      "replication_user" : "replicator",
      "replication_password" : "${random_password.mysqldb_replication_user_password[0].result}",
      "exporter_user" : "mysqld_exporter",
      "exporter_password" : "${random_password.mysqldb_exporter_user_password[0].result}"
  })
  content_type = "application/json"
  key_vault_id = azurerm_key_vault.mysql-secret[0].id
}

# Create a service principal for MySQL backup
resource "azurerm_user_assigned_identity" "mysql_backup_identity" {
  name                = format("%s-%s-%s", var.environment, var.name, "mysql_backup_identity")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

# Grant the storage blob contributor role to the backup service principal
resource "azurerm_role_assignment" "secretadmin_backup" {
  principal_id         = azurerm_user_assigned_identity.mysql_backup_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.storage_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

# Grant the "Managed Identity Token Creator" role to the backup service principal
resource "azurerm_role_assignment" "service_account_token_creator_backup" {
  principal_id         = azurerm_user_assigned_identity.mysql_backup_identity.principal_id
  role_definition_name = "Managed Identity Token Creator"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.storage_resource_group_name}"
}

# Create a service principal for MySQL restore
resource "azurerm_user_assigned_identity" "mysql_restore_identity" {
  name                = format("%s-%s-%s", var.environment, var.name, "mysql_restore_identity")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

# Grant the storage blob contributor role to the restore service principal
resource "azurerm_role_assignment" "secretadmin_restore" {
  principal_id         = azurerm_user_assigned_identity.mysql_restore_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.storage_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

# Grant the "Managed Identity Token Creator" role to the restore service principal
resource "azurerm_role_assignment" "service_account_token_creator_restore" {
  principal_id         = azurerm_user_assigned_identity.mysql_restore_identity.principal_id
  role_definition_name = "Managed Identity Token Creator"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.storage_resource_group_name}"
}

# Configure workload identity for MySQL backup
resource "azurerm_user_assigned_identity" "pod_identity_backup" {
  name                = format("%s-%s-%s", var.environment, var.name, "pod_identity_backup")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_role_assignment" "pod_identity_assignment_backup" {
  principal_id         = azurerm_user_assigned_identity.pod_identity_backup.principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.storage_resource_group_name}"
}
