locals {
  name        = "mysql"
  region      = "eastus"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                   = false
  namespace                          = ""
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
  custom_user_username       = "custom"
  azure_storage_account_name = ""
  azure_container_name       = ""
}

module "azure" {
  source                             = "saturnops/mysql/kubernetes//modules/resources/azure"
  cluster_name                       = ""
  resource_group_name                = ""
  resource_group_location            = ""
  environment                        = local.environment
  name                               = local.name
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  custom_user_username               = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
  storage_resource_group_name        = ""
  storage_account_name               = ""
}

module "mysql" {
  source           = "saturnops/mysql/kubernetes"
  create_namespace = local.create_namespace
  namespace        = local.namespace
  mysqldb_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    app_version                      = "8.0.29-debian-11-r9"
    architecture                     = "replication"
    custom_database                  = "test_db"
    storage_class_name               = "infra-service-sc"
    custom_user_username             = local.mysqldb_custom_credentials_enabled ? "" : local.custom_user_username
    primary_db_volume_size           = "10Gi"
    secondary_db_volume_size         = "10Gi"
    secondary_db_replica_count       = 2
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mysqldb_custom_credentials_enabled = local.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = local.mysqldb_custom_credentials_config
  root_password                      = local.mysqldb_custom_credentials_enabled ? "" : module.azure.root_password
  metric_exporter_pasword            = local.mysqldb_custom_credentials_enabled ? "" : module.azure.metric_exporter_pasword
  mysqldb_replication_user_password  = local.mysqldb_custom_credentials_enabled ? "" : module.azure.mysqldb_replication_user_password
  custom_user_password               = local.mysqldb_custom_credentials_enabled ? "" : module.azure.custom_user_password
  bucket_provider_type               = "azure"
  mysqldb_backup_enabled             = false
  mysqldb_backup_config = {
    bucket_uri                 = "https://${local.azure_storage_account_name}.blob.core.windows.net/${local.azure_container_name}"
    azure_storage_account_name = local.azure_storage_account_name
    azure_container_name       = local.azure_container_name
    cron_for_full_backup       = "* * 1 * *"
  }
  mysqldb_restore_enabled = false
  mysqldb_restore_config = {
    bucket_uri                 = "https://${local.azure_storage_account_name}.blob.core.windows.net/${local.azure_container_name}"
    azure_storage_account_name = local.azure_storage_account_name
    azure_container_name       = local.azure_container_name
    file_name                  = "mongodumpfull_20230710_132301.gz"
  }
  mysqldb_exporter_enabled = true
}
