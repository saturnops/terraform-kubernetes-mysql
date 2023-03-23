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

resource "aws_secretsmanager_secret" "mysql_user_password" {
  name                    = format("%s/%s/%s", var.mysqldb_config.environment, var.mysqldb_config.name, "mysql")
  recovery_window_in_days = var.recovery_window_aws_secret
}

resource "aws_secretsmanager_secret_version" "mysql_user_password" {
  secret_id     = aws_secretsmanager_secret.mysql_user_password.id
  secret_string = <<EOF
   {
    "root_user": "root",
    "root_password": "${random_password.mysqldb_root_password.result}",
    "custom_username": "${var.mysqldb_config.custom_user_username}",
    "custom_user_password": "${random_password.mysqldb_custom_user_password.result}",
    "replication_user": "replicator",
    "replication_password": "${random_password.mysqldb_replication_user_password.result}",
    "exporter_user": "mysqld_exporter",
    "exporter_password": "${random_password.mysqldb_exporter_user_password.result}"
   }
EOF
}

resource "kubernetes_namespace" "mysqldb" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}

    name = var.namespace
  }
}

resource "helm_release" "mysqldb" {
  depends_on = [kubernetes_namespace.mysqldb]

  name       = "mysqldb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  namespace  = var.namespace
  version    = var.chart_version
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/values/mysqldb/values.yaml", {
      app_version                 = var.app_version,
      architecture                = var.mysqldb_config.architecture,
      mysqldb_root_password       = random_password.mysqldb_root_password.result,
      custom_user_username        = var.mysqldb_config.custom_user_username,
      custom_user_password        = random_password.mysqldb_custom_user_password.result,
      replication_password        = random_password.mysqldb_replication_user_password.result,
      primary_pod_size            = var.mysqldb_config.primary_pod_volume_size,
      secondary_pod_replica_count = var.mysqldb_config.secondary_pod_replica_count,
      secondary_pod_size          = var.mysqldb_config.secondary_pod_volume_size,
      metrics_exporter_password   = random_password.mysqldb_exporter_user_password.result,
      mysqldb_exporter_enabled    = var.mysqldb_exporter_enabled,
      storage_class_name          = var.mysqldb_config.storage_class_name
    }),
    var.mysqldb_config.values_yaml
  ]
}

resource "helm_release" "mysqldb_backup" {
  depends_on = [helm_release.mysqldb]
  count      = var.mysqldb_backup_enabled ? 1 : 0
  name       = "mysqldb-backup"
  chart      = "${path.module}/backup"
  namespace  = var.namespace
  timeout    = 600
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      s3_bucket_uri        = var.mysqldb_backup_config.s3_bucket_uri,
      s3_bucket_region     = var.mysqldb_backup_config.s3_bucket_region,
      cron_for_full_backup = var.mysqldb_backup_config.cron_for_full_backup,
      custom_user_username = "root",
      s3_role_arn          = aws_iam_role.mysql_backup_role.arn
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
            "s3:ListBucket",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject",
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
