# aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.mysql_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.mysql_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_secretsmanager_secret.mysql_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mysql_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the MySQL application on. | `string` | `""` | no |
| <a name="input_mysqldb_config"></a> [mysqldb\_config](#input\_mysqldb\_config) | Specify the configuration settings for MySQL, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "custom_user_username": "",<br>  "environment": "",<br>  "name": "",<br>  "primary_db_volume_size": "",<br>  "secondary_db_replica_count": 1,<br>  "secondary_db_volume_size": "",<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_config"></a> [mysqldb\_custom\_credentials\_config](#input\_mysqldb\_custom\_credentials\_config) | Specify the configuration settings for MySQL to pass custom credentials during creation | `any` | <pre>{<br>  "custom_user_password": "",<br>  "custom_username": "",<br>  "exporter_password": "",<br>  "exporter_user": "",<br>  "replication_password": "",<br>  "replication_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_enabled"></a> [mysqldb\_custom\_credentials\_enabled](#input\_mysqldb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MySQL database. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the MYSQL deployment will be deployed. | `string` | `"mysqldb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#output\_iam\_role\_arn\_backup) | IAM role arn for mysql backup |
| <a name="output_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#output\_iam\_role\_arn\_restore) | IAM role arn for mysql restore |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
