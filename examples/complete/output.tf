output "mysql_port" {
  value = "3306"
}

output "mysql_primary_endpoint" {
  value = module.mysql.mysql_primary_endpoint
}

output "mysql_primary_headless_endpoint" {
  value = module.mysql.mysql_primary_headless_endpoint
}

output "mysql_secondary_endpoint" {
  value = module.mysql.mysql_secondary_endpoint
}

output "mysql_secondary_headless_endpoint" {
  value = module.mysql.mysql_secondary_headless_endpoint
}
