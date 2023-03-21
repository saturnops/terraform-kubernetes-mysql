output "mysql_port" {
  value = "3306"
}

output "mysql_primary_endpoint" {
  value = "mysqldb-primary.${var.namespace}.svc.cluster.local"
}

output "mysql_primary_headless_endpoint" {
  value = "mysqldb-primary-headless.${var.namespace}.svc.cluster.local"
}

output "mysql_secondary_endpoint" {
  value = "mysqldb-secondary.${var.namespace}.svc.cluster.local"
}

output "mysql_secondary_headless_endpoint" {
  value = "mysqldb-secondary-headless.${var.namespace}.svc.cluster.local"
}
