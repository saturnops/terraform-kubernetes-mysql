locals {
  name        = "mysql"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  store_password_to_secret_manager = true
}

module "mysql" {
  source       = "saturnops/mysql/kubernetes"
  cluster_name = ""
  project_id   = "" #for gcp
  mysqldb_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    architecture                     = "replication"
    storage_class_name               = "gp3"
    custom_user_username             = "admin"
    primary_db_volume_size           = "10Gi"
    secondary_db_volume_size         = "10Gi"
    secondary_db_replica_count       = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mysqldb_custom_credentials_enabled = true
  mysqldb_custom_credentials_config = {
    root_user            = "root"
    root_password        = "RJDRIFsYC8ZS1WQuV0ps"
    custom_username      = "admin"
    custom_user_password = "NCPFUKEMd7rrWuvMAa73"
    replication_user     = "replicator"
    replication_password = "nvAHhm1uGQNYWVw6ZyAH"
    exporter_user        = "mysqld_exporter"
    exporter_password    = "ZawhvpueAehRdKFlbjaq"
  }
  bucket_provider_type   = "gcs"
  mysqldb_backup_enabled = true
  mysqldb_backup_config = {
    bucket_uri           = "gs://mysql-backup-skaf"
    s3_bucket_region     = ""
    cron_for_full_backup = "*/5 * * * *"
  }
  mysqldb_restore_enabled = true
  mysqldb_restore_config = {
    bucket_uri       = "gs://mysql-backup-skaf/mysqldump_20230710_120501.zip"
    file_name        = "mysqldump_20230710_120501.zip"
    s3_bucket_region = ""
  }
  mysqldb_exporter_enabled = true
}
