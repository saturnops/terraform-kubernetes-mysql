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
      custom_user_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.custom_user_password : var.custom_user_password,
      replication_password        = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.replication_password : var.mysqldb_replication_user_password,
      mysqldb_root_password       = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.root_password : var.root_password,
      mysqldb_exporter_enabled    = var.mysqldb_exporter_enabled,
      service_monitor_namespace   = var.namespace
      metrics_exporter_password   = var.mysqldb_custom_credentials_enabled ? var.mysqldb_custom_credentials_config.exporter_password : var.metric_exporter_pasword,
      secondary_pod_replica_count = var.mysqldb_config.secondary_db_replica_count
    }),
    var.mysqldb_config.values_yaml
  ]
}

resource "helm_release" "mysqldb_backup" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_backup_enabled ? 1 : 0
  name       = "mysqldb-backup"
  chart      = "${path.module}/modules/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      bucket_uri           = var.mysqldb_backup_config.bucket_uri,
      s3_bucket_region     = var.bucket_provider_type == "s3" ? var.mysqldb_backup_config.s3_bucket_region : "",
      cron_for_full_backup = var.mysqldb_backup_config.cron_for_full_backup,
      custom_user_username = "root",
      bucket_provider_type = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations          = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${var.iam_role_arn_backup}" : "iam.gke.io/gcp-service-account: ${var.service_account_backup}"
    })
  ]
}


## DB dump restore
resource "helm_release" "mysqldb_restore" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_restore_enabled ? 1 : 0
  name       = "mysqldb-restore"
  chart      = "${path.module}/modules/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/restore/values.yaml", {
      bucket_uri           = var.mysqldb_restore_config.bucket_uri,
      file_name            = var.mysqldb_restore_config.file_name,
      s3_bucket_region     = var.bucket_provider_type == "s3" ? var.mysqldb_restore_config.s3_bucket_region : "",
      custom_user_username = "root",
      bucket_provider_type = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations          = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${var.iam_role_arn_restore}" : "iam.gke.io/gcp-service-account: ${var.service_account_restore}"
    })
  ]
}
