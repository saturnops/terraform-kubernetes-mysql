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
  description = "Specify the configuration settings for MySQL, including the name, environment, storage options, replication settings, and custom YAML values."
}

variable "root_password" {
  description = "Root user password for MySQL"
  type        = string
}

variable "custom_user_password" {
  description = "Password for the custom MySQL user"
  type        = string
}

variable "replication_password" {
  description = "Password for the replication user"
  type        = string
}

variable "exporter_password" {
  description = "Password for the mysqld_exporter user"
  type        = string
}
