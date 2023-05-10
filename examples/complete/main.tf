locals {
  name        = "mysql"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "mysql" {
  source       = "https://github.com/sq-ia/terraform-kubernetes-mysql.git"
  cluster_name = ""
  mysqldb_config = {
    name                       = local.name
    values_yaml                = file("./helm/values.yaml")
    environment                = local.environment
    architecture               = "replication"
    storage_class_name         = "infra-service-sc"
    custom_user_username       = "admin"
    primary_db_volume_size     = "10Gi"
    secondary_db_volume_size   = "10Gi"
    secondary_db_replica_count = 2
  }
  mysqldb_backup_enabled = true
  mysqldb_backup_config = {
    s3_bucket_uri        = "s3://mysqlbackupp"
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "*/2 * * * *"
  }
  mysqldb_restore_enabled = true
  mysqldb_restore_config = {
    s3_bucket_uri    = "s3://mysqldumprestore/10-dump.sql"
    s3_bucket_region = "us-east-2"
  }
  mysqldb_exporter_enabled = false
}
