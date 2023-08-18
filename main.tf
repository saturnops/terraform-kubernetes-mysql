

resource "random_password" "mysqldb_root_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_custom_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_replication_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_exporter_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "kubernetes_namespace" "mysqldb" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "mysqldb" {
  depends_on = [kubernetes_namespace.mysqldb]
  name       = "mysqldb"
  chart      = "mysql"
  version    = var.chart_version
  timeout    = 600
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  values = [
    templatefile("${path.module}/helm/values/mysqldb/values.yaml", {
      app_version                 = var.app_version,
      architecture                = var.mysqldb_config.architecture,
      primary_pod_size            = var.mysqldb_config.primary_db_volume_size,
      secondary_pod_size          = var.mysqldb_config.secondary_db_volume_size,
      storage_class_name          = var.mysqldb_config.storage_class_name,
      custom_user_username        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_username : var.mysqldb_config.custom_user_username,
      custom_user_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_user_password : random_password.mysqldb_custom_user_password[0].result,
      replication_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_password : random_password.mysqldb_replication_user_password[0].result,
      mysqldb_root_password       = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.root_password : random_password.mysqldb_root_password[0].result,
      mysqldb_exporter_enabled    = var.mysqldb_exporter_enabled,
      service_monitor_namespace   = var.namespace
      metrics_exporter_password   = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_password : random_password.mysqldb_exporter_user_password[0].result,
      secondary_pod_replica_count = var.mysqldb_config.secondary_db_replica_count
    }),
    var.mysqldb_config.values_yaml
  ]
}

module "aws" {
  source                             = "./provider/aws"
  count                              = var.bucket_provider_type == "s3" ? 1 : 0
  mysqldb_config                     = var.mysqldb_config
  recovery_window_aws_secret         = var.recovery_window_aws_secret
  cluster_name                       = var.cluster_name
  store_password_to_secret_manager   = var.store_password_to_secret_manager
  mysqldb_custom_credentials_enabled = var.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = var.mysqldb_custom_credentials_config
}

module "gcp" {
  source                             = "./provider/gcp"
  count                              = var.bucket_provider_type == "gcs" ? 1 : 0
  project_id                         = var.project_id
  environment                        = var.mysqldb_config.environment
  mysqldb_config                     = var.mysqldb_config
  store_password_to_secret_manager   = var.store_password_to_secret_manager
  mysqldb_custom_credentials_enabled = var.mysqldb_custom_credentials_enabled
  mysqldb_custom_credentials_config  = var.mysqldb_custom_credentials_config
}

resource "helm_release" "mysqldb_backup" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_backup_enabled ? 1 : 0
  name       = "mysqldb-backup"
  chart      = "${path.module}/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      bucket_uri           = var.mysqldb_backup_config.bucket_uri,
      s3_bucket_region     = var.bucket_provider_type == "s3" ? var.mysqldb_backup_config.s3_bucket_region : "",
      cron_for_full_backup = var.mysqldb_backup_config.cron_for_full_backup,
      custom_user_username = "root",
      bucket_provider_type = var.bucket_provider_type,
      annotations          = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${module.aws[0].iam_role_arn_backup}" : "iam.gke.io/gcp-service-account: ${module.gcp[0].service_account_backup}"
    })
  ]
}


## DB dump restore
resource "helm_release" "mysqldb_restore" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_restore_enabled ? 1 : 0
  name       = "mysqldb-restore"
  chart      = "${path.module}/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/restore/values.yaml", {
      bucket_uri           = var.mysqldb_restore_config.bucket_uri,
      file_name            = var.mysqldb_restore_config.file_name,
      s3_bucket_region     = var.bucket_provider_type == "s3" ? var.mysqldb_restore_config.s3_bucket_region : "",
      custom_user_username = "root",
      bucket_provider_type = var.bucket_provider_type,
      annotations          = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${module.aws[0].iam_role_arn_restore}" : "iam.gke.io/gcp-service-account: ${module.gcp[0].service_account_restore}"
    })
  ]
}
