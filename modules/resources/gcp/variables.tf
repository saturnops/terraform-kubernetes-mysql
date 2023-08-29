variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
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

variable "name" {
  description = "Name identifier for module to be added as suffix to resources"
  type        = string
  default     = "test"
}

variable "environment" {
  description = "Environment in which the infrastructure is being deployed (e.g., production, staging, development)"
  type        = string
  default     = "test"
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

variable "store_password_to_secret_manager" {
  type        = bool
  default     = false
  description = "Specifies whether to store the credentials in GCP secret manager."
}

variable "custom_user_username" {
  type    = string
  default = ""
}
