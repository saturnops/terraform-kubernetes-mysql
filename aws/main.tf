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

resource "aws_secretsmanager_secret" "mysql_user_password" {
  name                    = format("%s/%s/%s", var.mysqldb_config.environment, var.mysqldb_config.name, "mysql")
  recovery_window_in_days = var.recovery_window_aws_secret
}

resource "aws_secretsmanager_secret_version" "mysql_user_password" {
  secret_id     = aws_secretsmanager_secret.mysql_user_password.id
  secret_string = <<EOF
   {
    "root_user": "root",
    "root_password": "${var.root_password}",
    "custom_username": "${var.mysqldb_config.custom_user_username}",
    "custom_user_password": "${var.custom_user_password}",
    "replication_user": "replicator",
    "replication_password": "${var.replication_password}",
    "exporter_user": "mysqld_exporter",
    "exporter_password": "${var.exporter_password}"
   }
EOF
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

output "iam_role_arn_backup" {
  value = aws_iam_role.mysql_backup_role.arn
  description = "IAM role arn for mysql backup"
}

output "iam_role_arn_restore" {
  value = aws_iam_role.mysql_restore_role.arn
  description = "IAM role arn for mysql restore"
}