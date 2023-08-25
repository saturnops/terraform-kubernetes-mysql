# gcp

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

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
| [random_password.mysqldb_custom_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_exporter_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_replication_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_user_username"></a> [custom\_user\_username](#input\_custom\_user\_username) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_gcp_gsa_backup_name"></a> [gcp\_gsa\_backup\_name](#input\_gcp\_gsa\_backup\_name) | Google Cloud Service Account name for backup | `string` | `"mysql-backup"` | no |
| <a name="input_gcp_gsa_restore_name"></a> [gcp\_gsa\_restore\_name](#input\_gcp\_gsa\_restore\_name) | Google Cloud Service Account name for restore | `string` | `"mysql-restore"` | no |
| <a name="input_gcp_ksa_backup_name"></a> [gcp\_ksa\_backup\_name](#input\_gcp\_ksa\_backup\_name) | Google Kubernetes Service Account name for backup | `string` | `"sa-mysql-backup"` | no |
| <a name="input_gcp_ksa_restore_name"></a> [gcp\_ksa\_restore\_name](#input\_gcp\_ksa\_restore\_name) | Google Kubernetes Service Account name for restore | `string` | `"sa-mysql-restore"` | no |
| <a name="input_mysqldb_custom_credentials_config"></a> [mysqldb\_custom\_credentials\_config](#input\_mysqldb\_custom\_credentials\_config) | Specify the configuration settings for MySQL to pass custom credentials during creation | `any` | <pre>{<br>  "custom_user_password": "",<br>  "custom_username": "",<br>  "exporter_password": "",<br>  "exporter_user": "",<br>  "replication_password": "",<br>  "replication_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_enabled"></a> [mysqldb\_custom\_credentials\_enabled](#input\_mysqldb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MySQL database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_user_password"></a> [custom\_user\_password](#output\_custom\_user\_password) | custom user's password of mysqldb |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mysqldb\_exporter user's password of mysqldb |
| <a name="output_mysqldb_replication_user_password"></a> [mysqldb\_replication\_user\_password](#output\_mysqldb\_replication\_user\_password) | replicator user's password of mysqldb |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of mysqldb |
| <a name="output_service_account_backup"></a> [service\_account\_backup](#output\_service\_account\_backup) | Google Cloud Service Account name for backup |
| <a name="output_service_account_restore"></a> [service\_account\_restore](#output\_service\_account\_restore) | Google Cloud Service Account name for restore |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
