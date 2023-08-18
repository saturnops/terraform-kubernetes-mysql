output "mysqldb_endpoints" {
  description = "MySQL endpoints in the Kubernetes cluster."
  value = {
    mysqlport                         = "3306",
    mysql_primary_endpoint            = "mysqldb-primary.${var.namespace}.svc.cluster.local",
    mysql_primary_headless_endpoint   = "mysqldb-primary-headless.${var.namespace}.svc.cluster.local",
    mysql_secondary_endpoint          = "mysqldb-secondary.${var.namespace}.svc.cluster.local",
    mysql_secondary_headless_endpoint = "mysqldb-secondary-headless.${var.namespace}.svc.cluster.local",
  }
}

output "mysqldb_credential" {
  description = "MySQL credentials used for accessing the MySQL database."
  value = var.mysqldb_config.store_password_to_secret_manager ? null : {
    root_user            = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.root_user : "root",
    root_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.root_password : nonsensitive(random_password.mysqldb_root_password[0].result),
    custom_username      = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_username : var.mysqldb_config.custom_user_username,
    custom_user_password = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_user_password : nonsensitive(random_password.mysqldb_custom_user_password[0].result),
    replication_user     = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_user : "replicator",
    replication_password = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_password : nonsensitive(random_password.mysqldb_replication_user_password[0].result),
    exporter_user        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_user : "mysqld_exporter",
    exporter_password    = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_password : nonsensitive(random_password.mysqldb_exporter_user_password[0].result)
  }
}
