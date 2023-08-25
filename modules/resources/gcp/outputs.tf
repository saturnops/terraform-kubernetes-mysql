output "service_account_backup" {
  value       = google_service_account.mysql_backup.email
  description = "Google Cloud Service Account name for backup"
}

output "service_account_restore" {
  value       = google_service_account.mysql_restore.email
  description = "Google Cloud Service Account name for restore"
}

output "root_password" {
  value       = var.mysqldb_custom_credentials_enabled ? null : nonsensitive(random_password.mysqldb_root_password[0].result)
  description = "Root user's password of mysqldb"
}

output "metric_exporter_pasword" {
  value       = var.mysqldb_custom_credentials_enabled ? null : nonsensitive(random_password.mysqldb_exporter_user_password[0].result)
  description = "mysqldb_exporter user's password of mysqldb"
}

output "mysqldb_replication_user_password" {
  value       = var.mysqldb_custom_credentials_enabled ? null : nonsensitive(random_password.mysqldb_replication_user_password[0].result)
  description = "replicator user's password of mysqldb"
}

output "custom_user_password" {
  value       = var.mysqldb_custom_credentials_enabled ? null : nonsensitive(random_password.mysqldb_custom_user_password[0].result)
  description = "custom user's password of mysqldb"
}
