output "mysql_endpoints" {
  value       = module.mysql.mysqldb_endpoints
  description = "MySQL endpoints in the Kubernetes cluster."
}

output "mysql_credential" {
  value       = local.store_password_to_secret_manager ? null : module.mysql.mysqldb_credential
  description = "MySQL credentials used for accessing the MySQL database."
}
