variable "mysqldb_config" {
  type = any
  default = {
    name                       = ""
    environment                = ""
    values_yaml                = ""
    architecture               = ""
    storage_class_name         = ""
    custom_user_username       = ""
    primary_db_volume_size     = ""
    secondary_db_volume_size   = ""
    secondary_db_replica_count = 1
  }
  description = "Mysql configurations"
}

variable "app_version" {
  type        = string
  default     = "8.0.29-debian-11-r9"
  description = "App version"
}

variable "chart_version" {
  type        = string
  default     = "9.2.0"
  description = "Chart version"
}

variable "namespace" {
  type        = string
  default     = "mysqldb"
  description = "Namespace name"
}
variable "mysqldb_backup_enabled" {
  type        = bool
  default     = false
  description = "Set true to enable mysql backups"
}

variable "mysqldb_backup_config" {
  type = any
  default = {
    s3_bucket_uri        = ""
    s3_bucket_region     = ""
    cron_for_full_backup = ""
  }
  description = "Mysql Backup configurations"
}

variable "mysqldb_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set true to deploy mysqldb exporters to get metrics in grafana"
}

variable "recovery_window_aws_secret" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the EKS cluster"
}

variable "create_namespace" {
  type        = string
  description = "Set it to true to create given namespace"
  default     = true
}

variable "mysqldb_restore_enabled" {
  type        = bool
  default     = true
  description = "Set true to enable mysql restore"
}

variable "mysqldb_restore_config" {
  type = any
  default = {
    s3_bucket_uri    = ""
    s3_bucket_region = ""
  }
  description = "Mysql Restore configurations"
}
