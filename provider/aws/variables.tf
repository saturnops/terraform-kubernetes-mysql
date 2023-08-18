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

variable "namespace" {
  type        = string
  default     = "mysqldb"
  description = "Name of the Kubernetes namespace where the MYSQL deployment will be deployed."
}
