output "mysqldb_endpoints" {
  description = "Mysql_Info"
  value = {
    mysqlport                         = "3306",
    mysql_primary_endpoint            = "mysqldb-primary.${var.namespace}.svc.cluster.local",
    mysql_primary_headless_endpoint   = "mysqldb-primary-headless.${var.namespace}.svc.cluster.local",
    mysql_secondary_endpoint          = "mysqldb-secondary.${var.namespace}.svc.cluster.local",
    mysql_secondary_headless_endpoint = "mysqldb-secondary-headless.${var.namespace}.svc.cluster.local",
  }
}

output "mysqldb_credential" {
  description = "Mysql_Info"
  value = var.mysqldb_config.store_password_to_secret_manager ? null : {
    root_user            = "root",
    root_password        = nonsensitive(random_password.mysqldb_root_password.result),
    custom_username      = var.mysqldb_config.custom_user_username,
    custom_user_password = nonsensitive(random_password.mysqldb_custom_user_password.result),
    replication_user     = "replicator",
    replication_password = nonsensitive(random_password.mysqldb_replication_user_password.result),
    exporter_user        = "mysqld_exporter",
    exporter_password    = nonsensitive(random_password.mysqldb_exporter_user_password.result)
  }
}
