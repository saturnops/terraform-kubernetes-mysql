output "mysqldb" {
  description = "Mysql_Info"
  value = {
    mysqlport                         = "3306",
    mysql_primary_endpoint            = "mysqldb-primary.${var.namespace}.svc.cluster.local",
    mysql_primary_headless_endpoint   = "mysqldb-primary-headless.${var.namespace}.svc.cluster.local",
    mysql_secondary_endpoint          = "mysqldb-secondary.${var.namespace}.svc.cluster.local",
    mysql_secondary_headless_endpoint = "mysqldb-secondary-headless.${var.namespace}.svc.cluster.local"
  }
}
