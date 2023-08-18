# gcp

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_secret_manager_secret.mysql-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.mysql-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.mysql_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.mysql_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.pod_identity_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_gcp_gsa_backup_name"></a> [gcp\_gsa\_backup\_name](#input\_gcp\_gsa\_backup\_name) | Google Cloud Service Account name for backup | `string` | `"mysql-backup"` | no |
| <a name="input_gcp_gsa_restore_name"></a> [gcp\_gsa\_restore\_name](#input\_gcp\_gsa\_restore\_name) | Google Cloud Service Account name for restore | `string` | `"mysql-restore"` | no |
| <a name="input_gcp_ksa_backup_name"></a> [gcp\_ksa\_backup\_name](#input\_gcp\_ksa\_backup\_name) | Google Kubernetes Service Account name for backup | `string` | `"sa-mysql-backup"` | no |
| <a name="input_gcp_ksa_restore_name"></a> [gcp\_ksa\_restore\_name](#input\_gcp\_ksa\_restore\_name) | Google Kubernetes Service Account name for restore | `string` | `"sa-mysql-restore"` | no |
| <a name="input_mysqldb_config"></a> [mysqldb\_config](#input\_mysqldb\_config) | Specify the configuration settings for MySQL, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "custom_user_username": "",<br>  "environment": "",<br>  "name": "",<br>  "primary_db_volume_size": "",<br>  "secondary_db_replica_count": 1,<br>  "secondary_db_volume_size": "",<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_config"></a> [mysqldb\_custom\_credentials\_config](#input\_mysqldb\_custom\_credentials\_config) | Specify the configuration settings for MySQL to pass custom credentials during creation | `any` | <pre>{<br>  "custom_user_password": "",<br>  "custom_username": "",<br>  "exporter_password": "",<br>  "exporter_user": "",<br>  "replication_password": "",<br>  "replication_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_enabled"></a> [mysqldb\_custom\_credentials\_enabled](#input\_mysqldb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MySQL database. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_backup"></a> [service\_account\_backup](#output\_service\_account\_backup) | Google Cloud Service Account name for backup |
| <a name="output_service_account_restore"></a> [service\_account\_restore](#output\_service\_account\_restore) | Google Cloud Service Account name for restore |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
