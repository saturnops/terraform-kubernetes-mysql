

resource "random_password" "mysqldb_root_password" {
  length  = 20
  special = false
}

resource "random_password" "mysqldb_custom_user_password" {
  length  = 20
  special = false
}

resource "random_password" "mysqldb_replication_user_password" {
  length  = 20
  special = false
}

resource "random_password" "mysqldb_exporter_user_password" {
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
      custom_user_username        = var.mysqldb_config.custom_user_username,
      custom_user_password        = random_password.mysqldb_custom_user_password.result,
      replication_password        = random_password.mysqldb_replication_user_password.result,
      mysqldb_root_password       = random_password.mysqldb_root_password.result,
      mysqldb_exporter_enabled    = var.mysqldb_exporter_enabled,
      service_monitor_namespace   = var.namespace
      metrics_exporter_password   = random_password.mysqldb_exporter_user_password.result,
      secondary_pod_replica_count = var.mysqldb_config.secondary_db_replica_count
    }),
    var.mysqldb_config.values_yaml
  ]
}

module "aws" {
  source = "./aws"
  count = var.provider_type == "aws" ? 1 : 0
  mysqldb_config = var.mysqldb_config
  recovery_window_aws_secret = var.recovery_window_aws_secret
  cluster_name = var.cluster_name
  root_password = random_password.mysqldb_root_password.result
  custom_user_password = random_password.mysqldb_custom_user_password.result
  replication_password = random_password.mysqldb_replication_user_password.result
  exporter_password = random_password.mysqldb_exporter_user_password.result
}

module "gcp" {
  source = "./gcp"
  count = var.provider_type == "gcp" ? 1 : 0
  project_id = var.project_id
  environment = var.environment
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
      bucket_uri        = var.mysqldb_backup_config.bucket_uri,
      s3_bucket_region     = var.provider_type == "aws" ? var.mysqldb_backup_config.s3_bucket_region : "",
      cron_for_full_backup = var.mysqldb_backup_config.cron_for_full_backup,
      custom_user_username = "root",
      provider_type = var.provider_type,
      annotations = var.provider_type == "aws" ? "eks.amazonaws.com/role-arn: ${module.aws.iam_role_arn_backup}" : "iam.gke.io/gcp-service-account: ${module.gcp.service_account_backup}"
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
      bucket_uri        = var.mysqldb_restore_config.bucket_uri,
      s3_bucket_region     = var.provider_type == "aws" ? var.mysqldb_restore_config.s3_bucket_region : "",
      custom_user_username = "root",
      provider_type = var.provider_type,
      annotations = var.provider_type == "aws" ? "eks.amazonaws.com/role-arn: ${module.aws.iam_role_arn_restore}" : "iam.gke.io/gcp-service-account: ${module.gcp.service_account_restore}"
    })
  ]
}

module "aws" {
  source = "./aws"

  count = var.provider_type == "aws" ? 1 : 0
  mysqldb_config = var.mysqldb_config
  recovery_window_aws_secret = var.recovery_window_aws_secret
  cluster_name = var.cluster_name
  
}

module "gcp" {
  source = "./gcp"

  count = var.provider_type == "gcp" ? 1 : 0
  project_id = var.project_id
  environment = var.environment
}