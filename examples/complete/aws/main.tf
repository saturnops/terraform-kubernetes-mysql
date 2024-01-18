locals {
  name        = "mysql"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                   = false
  namespace                          = "mysql"
  store_password_to_secret_manager   = false
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
  custom_user_username = "custom"
}

module "aws" {
  source                             = "saturnops/mysql/kubernetes//modules/resources/aws"
  cluster_name                       = "cluster-name"
  environment                        = local.environment
  name                               = local.name
  namespace                          = local.namespace
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  custom_user_username               = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
}

module "mysql" {
  source           = "saturnops/mysql/kubernetes"
  create_namespace = local.create_namespace
  namespace        = local.namespace
  mysqldb_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    app_version                      = "8.0.29-debian-11-r9"
    environment                      = local.environment
    architecture                     = "replication"
    custom_database                  = "test_db"
    storage_class_name               = "gp2"
    custom_user_username             = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
    primary_db_volume_size           = "10Gi"
    secondary_db_volume_size         = "10Gi"
    secondary_db_replica_count       = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  root_password                      = local.mysqldb_custom_credentials_enabled ? "" : module.aws.root_password
  metric_exporter_pasword            = local.mysqldb_custom_credentials_enabled ? "" : module.aws.metric_exporter_pasword
  mysqldb_replication_user_password  = local.mysqldb_custom_credentials_enabled ? "" : module.aws.mysqldb_replication_user_password
  custom_user_password               = local.mysqldb_custom_credentials_enabled ? "" : module.aws.custom_user_password
  bucket_provider_type               = "s3"
  iam_role_arn_backup                = module.aws.iam_role_arn_backup
  mysqldb_backup_enabled             = true
  mysqldb_backup_config = {
    mysql_database_name  = ""
    bucket_uri           = "s3://bucket_name/backup/"
    s3_bucket_region     = ""
    cron_for_full_backup = "*/5 * * * *"
  }
  mysqldb_restore_enabled = true
  iam_role_arn_restore    = module.aws.iam_role_arn_restore
  mysqldb_restore_config = {
    bucket_uri       = "s3://bucket_name/backup/mysqldump_20230710_120501.zip"
    file_name        = "mysqldump_20230710_120501.zip"
    s3_bucket_region = ""
  }
  mysqldb_exporter_enabled = true
}
