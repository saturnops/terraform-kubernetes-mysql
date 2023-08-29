output "iam_role_arn_backup" {
  value       = aws_iam_role.mysql_backup_role.arn
  description = "IAM role arn for mysql backup"
}

output "iam_role_arn_restore" {
  value       = aws_iam_role.mysql_restore_role.arn
  description = "IAM role arn for mysql restore"
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
