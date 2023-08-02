output "mysql_endpoints" {
  value       = module.mysql.mysqldb_endpoints
  description = "Mysql_Info"
}

output "mysql_credential" {
  value       = local.store_password_to_secret_manager ? null : module.mysql.mysqldb_credential
  description = "Mysql_Info"
}
