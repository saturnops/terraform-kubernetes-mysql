locals {
  oidc_provider = replace(
    data.aws_eks_cluster.kubernetes_cluster.identity[0].oidc[0].issuer,
    "/^https:///",
    ""
  )
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "kubernetes_cluster" {
  name = var.cluster_name
}

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

resource "aws_secretsmanager_secret" "mysql_user_password" {
  count                   = var.mysqldb_config.store_password_to_secret_manager ? 1 : 0
  name                    = format("%s/%s/%s", var.mysqldb_config.environment, var.mysqldb_config.name, "mysql")
  recovery_window_in_days = var.recovery_window_aws_secret
}

resource "aws_secretsmanager_secret_version" "mysql_user_password" {
  count     = var.mysqldb_config.store_password_to_secret_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.mysql_user_password[0].id
  secret_string = var.mysqldb_custom_credentials_enabled ? jsonencode(
    {
      "root_user" : "${var.mysqldb_custom_credentials_config.root_user}",
      "root_password" : "${var.mysqldb_custom_credentials_config.root_password}",
      "custom_username" : "${var.mysqldb_custom_credentials_config.custom_username}",
      "custom_user_password" : "${var.mysqldb_custom_credentials_config.custom_user_password}",
      "replication_user" : "${var.mysqldb_custom_credentials_config.replication_user}",
      "replication_password" : "${var.mysqldb_custom_credentials_config.replication_password}",
      "exporter_user" : "${var.mysqldb_custom_credentials_config.exporter_user}",
      "exporter_password" : "${var.mysqldb_custom_credentials_config.exporter_password}"
    }) : jsonencode(
    {
      "root_user" : "root",
      "root_password" : "${random_password.mysqldb_root_password[0].result}",
      "custom_username" : "${var.mysqldb_config.custom_user_username}",
      "custom_user_password" : "${random_password.mysqldb_custom_user_password[0].result}",
      "replication_user" : "replicator",
      "replication_password" : "${random_password.mysqldb_replication_user_password[0].result}",
      "exporter_user" : "mysqld_exporter",
      "exporter_password" : "${random_password.mysqldb_exporter_user_password[0].result}"
  })
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

resource "helm_release" "mysqldb_backup" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_backup_enabled ? 1 : 0
  name       = "mysqldb-backup"
  chart      = "${path.module}/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      s3_role_arn          = aws_iam_role.mysql_backup_role.arn
      s3_bucket_uri        = var.mysqldb_backup_config.s3_bucket_uri,
      s3_bucket_region     = var.mysqldb_backup_config.s3_bucket_region,
      cron_for_full_backup = var.mysqldb_backup_config.cron_for_full_backup,
      custom_user_username = "root"
    })
  ]
}

resource "aws_iam_role" "mysql_backup_role" {
  name = format("%s-%s-%s", var.cluster_name, var.mysqldb_config.name, "mysql-backup")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-mysql-backup"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
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
      s3_role_arn          = aws_iam_role.mysql_restore_role.arn
      s3_bucket_uri        = var.mysqldb_restore_config.s3_bucket_uri,
      s3_bucket_region     = var.mysqldb_restore_config.s3_bucket_region,
      custom_user_username = "root"
    })
  ]
}

resource "aws_iam_role" "mysql_restore_role" {
  name = format("%s-%s-%s", var.cluster_name, var.mysqldb_config.name, "mysql-restore")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-mysql-restore"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
