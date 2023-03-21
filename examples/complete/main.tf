locals {
  region      = "us-east-2"
  name        = "skaf"
  environment = "prod"
}

module "mysql" {
  source                   = "../.."
  mysqldb_backup_enabled   = true
  mysqldb_exporter_enabled = false
  cluster_name             = "cluster-name"
  mysqldb_config = {
    name                        = local.name
    environment                 = local.environment
    architecture                = "replication"
    custom_user_username        = "admin"
    primary_pod_volume_size     = "10Gi"
    secondary_pod_replica_count = 1
    secondary_pod_volume_size   = "10Gi"
    storage_class_name          = "infra-service-sc"
    values_yaml                 = file("./helm/values.yaml")
  }
  mysqldb_backup_config = {
    s3_bucket_uri        = "s3://bucketname"
    s3_bucket_region     = "bucket_region"
    cron_for_full_backup = "*/2 * * * *"
  }


}