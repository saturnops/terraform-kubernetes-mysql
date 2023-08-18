variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment in which the infrastructure is being deployed (e.g., production, staging, development)"
  type        = string
  default     = "test"
}

variable "gcp_gsa_backup_name" {
  description = "Google Cloud Service Account name for backup"
  type        = string
  default     = "mysql-backup"
}

variable "gcp_ksa_backup_name" {
  description = "Google Kubernetes Service Account name for backup"
  type        = string
  default     = "sa-mysql-backup"
}

variable "gcp_gsa_restore_name" {
  description = "Google Cloud Service Account name for restore"
  type        = string
  default     = "mysql-restore"
}

variable "gcp_ksa_restore_name" {
  description = "Google Kubernetes Service Account name for restore"
  type        = string
  default     = "sa-mysql-restore"
}

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
