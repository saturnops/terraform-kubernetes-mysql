variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default     = ""
}

variable "storage_resource_group_name" {
  description = "Azure Storage account Resource Group name"
  type        = string
  default     = ""
}

variable "resource_group_location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "name" {
  description = "Name identifier for module to be added as suffix to resources"
  type        = string
  default     = "test"
}

variable "cluster_name" {
  description = "Name of the Azure AKS cluster"
  type        = string
  default     = ""
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

variable "storage_account_name" {
  type    = string
  default = ""
}