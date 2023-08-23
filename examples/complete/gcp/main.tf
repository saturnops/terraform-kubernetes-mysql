locals {
  name        = "mysql"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  store_password_to_secret_manager   = true
  mysqldb_custom_credentials_enabled = false
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
  custom_user_username = "custom"
}

module "gcp" {
  source                             = "saturnops/mysql/kubernetes//provider/gcp"
  project_id                         = "fresh-sanctuary-387476" #for gcp
  environment                        = local.environment
  name                               = local.name
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  custom_user_username               = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
}

module "mysql" {
  source = "saturnops/mysql/kubernetes"
  mysqldb_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    architecture                     = "replication"
    storage_class_name               = "standard"
    custom_user_username             = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
    primary_db_volume_size           = "10Gi"
    secondary_db_volume_size         = "10Gi"
    secondary_db_replica_count       = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  root_password                      = local.mysqldb_custom_credentials_enabled ? "" : module.gcp.root_password
  metric_exporter_pasword            = local.mysqldb_custom_credentials_enabled ? "" : module.gcp.metric_exporter_pasword
  mysqldb_replication_user_password  = local.mysqldb_custom_credentials_enabled ? "" : module.gcp.mysqldb_replication_user_password
  custom_user_password               = local.mysqldb_custom_credentials_enabled ? "" : module.gcp.custom_user_password
  bucket_provider_type               = "gcs"
  service_account_backup             = module.gcp.service_account_backup
  service_account_restore            = module.gcp.service_account_restore
  mysqldb_backup_enabled             = true
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
