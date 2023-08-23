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
    root_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.root_password : var.root_password,
    custom_username      = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_username : var.mysqldb_config.custom_user_username,
    custom_user_password = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_user_password : var.custom_user_password,
    replication_user     = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_user : "replicator",
    replication_password = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_password : var.mysqldb_replication_user_password,
    exporter_user        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_user : "mysqld_exporter",
    exporter_password    = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_password : var.metric_exporter_pasword
  }
}
