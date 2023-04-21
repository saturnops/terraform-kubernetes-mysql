locals {
  name        = "test"
  region      = "ap-south-1"
  environment = "saturnops"
}

module "mysql" {
  source       = "../../"
  cluster_name = "test-saturnops"
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
    s3_bucket_uri    = "s3://mysqldumprestore/20-ratings.sql"
    s3_bucket_region = "us-east-2"

  }
  mysqldb_exporter_enabled = false
}
