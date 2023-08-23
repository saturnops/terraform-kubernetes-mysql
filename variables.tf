variable "mysqldb_config" {
  type = any
  default = {
    name                             = ""
    environment                      = ""
    values_yaml                      = ""
    architecture                     = ""
    storage_class_name               = ""
    custom_user_username             = ""
    primary_db_volume_size           = ""
    secondary_db_volume_size         = ""
    secondary_db_replica_count       = 1
    store_password_to_secret_manager = true
  }
  description = "Specify the configuration settings for MySQL, including the name, environment, storage options, replication settings, and custom YAML values."
}

variable "mysqldb_custom_credentials_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable custom credentials for MySQL database."
}

variable "mysqldb_custom_credentials_config" {
  type = any
  default = {
    root_user            = ""
    root_password        = ""
    custom_username      = ""
    custom_user_password = ""
    replication_user     = ""
    replication_password = ""
    exporter_user        = ""
    exporter_password    = ""
  }
  description = "Specify the configuration settings for MySQL to pass custom credentials during creation"
}

variable "app_version" {
  type        = string
  default     = "8.0.29-debian-11-r9"
  description = "Version of the MySQL application that will be deployed."
}

variable "chart_version" {
  type        = string
  default     = "9.2.0"
  description = "Version of the Mysql chart that will be used to deploy MySQL application."
}

variable "namespace" {
  type        = string
  default     = "mysqldb"
  description = "Name of the Kubernetes namespace where the MYSQL deployment will be deployed."
}
variable "mysqldb_backup_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable backups for MySQL database."
}

variable "mysqldb_backup_config" {
  type = any
  default = {
    bucket_uri           = ""
    s3_bucket_region     = ""
    cron_for_full_backup = ""
  }
  description = "configuration options for MySQL database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups."
}

variable "mysqldb_exporter_enabled" {
  type        = bool
  default     = false
  description = "Specify whether or not to deploy Mysql exporter to collect Mysql metrics for monitoring in Grafana."
}

variable "recovery_window_aws_secret" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the MySQL application on."
}

variable "create_namespace" {
  type        = string
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
  default     = true
}

variable "mysqldb_restore_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable restoring dump to the MySQL database."
}

variable "mysqldb_restore_config" {
  type = any
  default = {
    bucket_uri       = ""
    file_name        = ""
    s3_bucket_region = ""
  }
  description = "Configuration options for restoring dump to the MySQL database."
}

variable "bucket_provider_type" {
  type        = string
  default     = "gcs"
  description = "Choose what type of provider you want (s3, gcs)"
}


variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
}

variable "iam_role_arn_backup" {
  description = "IAM role ARN for backup (AWS)"
  type        = string
  default     = ""
}

variable "service_account_backup" {
  description = "Service account for backup (GCP)"
  type        = string
  default     = ""
}

variable "iam_role_arn_restore" {
  description = "IAM role ARN for restore (AWS)"
  type        = string
  default     = ""
}

variable "service_account_restore" {
  description = "Service account for restore (GCP)"
  type        = string
  default     = ""
}

variable "root_password" {
  description = "Root password for MongoDB"
  type        = string
  default     = ""
}

variable "metric_exporter_pasword" {
  description = "Metric exporter password for MongoDB"
  type        = string
  default     = ""
}

variable "custom_user_password" {
  description = "custom user password for MongoDB"
  type        = string
  default     = ""
}

variable "mysqldb_replication_user_password" {
  description = "Replicator password for MongoDB"
  type        = string
  default     = ""
}
