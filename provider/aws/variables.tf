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
variable "namespace" {
  type        = string
  default     = "mysqldb"
  description = "Name of the Kubernetes namespace where the MYSQL deployment will be deployed."
}
