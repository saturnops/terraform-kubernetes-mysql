variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default = ""
}

variable "environment" {
  description = "Environment in which the infrastructure is being deployed (e.g., production, staging, development)"
  type        = string
  default = "test"
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
