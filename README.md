## MySQL DB Terraform Module


<br>

## Usage Example

```hcl
module "mysql" {
  source                   = "../.."
  cluster_name             = "dev-skaf"
  mysqldb_config = {
    name                       = "skaf"
    values_yaml                = ""
    environment                = "prod"
    architecture               = "replication"
    storage_class_name         = "infra-service-sc"
    custom_user_username       = "admin"
    primary_db_volume_size     = "10Gi"
    secondary_db_volume_size   = "10Gi"
    secondary_db_replica_count = 2
  }
  mysqldb_backup_enabled   = true
  mysqldb_backup_config = {
    s3_bucket_uri        = "s3://bucket-name"
    s3_bucket_region     = "bucket-region"
    cron_for_full_backup = "*/2 * * * *"
  }
  mysqldb_exporter_enabled = true
}


```
Refer [examples](https://github.com/sq-ia/terraform-kubernetes-mysql/tree/main/examples/complete) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/sq-ia/terraform-kubernetes-mysql/blob/main/IAM.md)

## Important Notes
  1. In order to enable the exporter, it is required to deploy Prometheus/Grafana first.
  2. The exporter is a tool that extracts metrics data from an application or system and makes it available to be scraped by Prometheus.
  3. Prometheus is a monitoring system that collects metrics data from various sources, including exporters, and stores it in a time-series database.
  4. Grafana is a data visualization and dashboard tool that works with Prometheus and other data sources to display the collected metrics in a user-friendly way.
  5. To deploy Prometheus/Grafana, please follow the installation instructions for each tool in their respective documentation.
  6. Once Prometheus and Grafana are deployed, the exporter can be configured to scrape metrics data from your application or system and send it to Prometheus.
  7. Finally, you can use Grafana to create custom dashboards and visualize the metrics data collected by Prometheus.
  8. This module is compatible with EKS version 1.23, which is great news for users deploying the module on an EKS cluster running that version. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.mysql_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.mysql_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_secretsmanager_secret.mysql_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mysql_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [helm_release.mysqldb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mysqldb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mysqldb_restore](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mysqldb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_password.mysqldb_custom_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_exporter_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_replication_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_version"></a> [app\_version](#input\_app\_version) | App version | `string` | `"8.0.29-debian-11-r9"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Chart version | `string` | `"9.2.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Set it to true to create given namespace | `string` | `true` | no |
| <a name="input_mysqldb_backup_config"></a> [mysqldb\_backup\_config](#input\_mysqldb\_backup\_config) | Mysql Backup configurations | `any` | <pre>{<br>  "cron_for_full_backup": "",<br>  "s3_bucket_region": "",<br>  "s3_bucket_uri": ""<br>}</pre> | no |
| <a name="input_mysqldb_backup_enabled"></a> [mysqldb\_backup\_enabled](#input\_mysqldb\_backup\_enabled) | Set true to enable mysql backups | `bool` | `false` | no |
| <a name="input_mysqldb_config"></a> [mysqldb\_config](#input\_mysqldb\_config) | Mysql configurations | `any` | <pre>{<br>  "architecture": "",<br>  "custom_user_username": "",<br>  "environment": "",<br>  "name": "",<br>  "primary_db_volume_size": "",<br>  "secondary_db_replica_count": 1,<br>  "secondary_db_volume_size": "",<br>  "storage_class_name": "",<br>  "values_yaml": ""<br>}</pre> | no |
| <a name="input_mysqldb_exporter_enabled"></a> [mysqldb\_exporter\_enabled](#input\_mysqldb\_exporter\_enabled) | Set true to deploy mysqldb exporters to get metrics in grafana | `bool` | `false` | no |
| <a name="input_mysqldb_restore_config"></a> [mysqldb\_restore\_config](#input\_mysqldb\_restore\_config) | Mysql Restore configurations | `any` | <pre>{<br>  "s3_bucket_region": "",<br>  "s3_bucket_uri": ""<br>}</pre> | no |
| <a name="input_mysqldb_restore_enabled"></a> [mysqldb\_restore\_enabled](#input\_mysqldb\_restore\_enabled) | Set true to enable mysql restore | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | `"mysqldb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysqldb"></a> [mysqldb](#output\_mysqldb) | MysqlDB\_Info |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->






##           





Please give our GitHub repository a ⭐️ to show your support and increase its visibility.





