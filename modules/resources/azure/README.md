# Azure Provider Module

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.mysql-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.mysql-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.pod_identity_assignment_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.mysql_backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.mysql_restore_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.mysqldb_custom_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_exporter_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_replication_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Azure AKS cluster | `string` | `""` | no |
| <a name="input_custom_user_username"></a> [custom\_user\_username](#input\_custom\_user\_username) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_mysqldb_custom_credentials_config"></a> [mysqldb\_custom\_credentials\_config](#input\_mysqldb\_custom\_credentials\_config) | Specify the configuration settings for MySQL to pass custom credentials during creation | `any` | <pre>{<br>  "custom_user_password": "",<br>  "custom_username": "",<br>  "exporter_password": "",<br>  "exporter_user": "",<br>  "replication_password": "",<br>  "replication_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_enabled"></a> [mysqldb\_custom\_credentials\_enabled](#input\_mysqldb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MySQL database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | n/a | `string` | `""` | no |
| <a name="input_storage_resource_group_name"></a> [storage\_resource\_group\_name](#input\_storage\_resource\_group\_name) | Azure Storage account Resource Group name | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_user_password"></a> [custom\_user\_password](#output\_custom\_user\_password) | custom user's password of mysqldb |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mysqldb\_exporter user's password of mysqldb |
| <a name="output_mysqldb_replication_user_password"></a> [mysqldb\_replication\_user\_password](#output\_mysqldb\_replication\_user\_password) | replicator user's password of mysqldb |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of mysqldb |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.mysql-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.mysql-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.pod_identity_assignment_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.mysql_backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.mysql_restore_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.mysqldb_custom_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_exporter_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_replication_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysqldb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Azure AKS cluster | `string` | `""` | no |
| <a name="input_custom_user_username"></a> [custom\_user\_username](#input\_custom\_user\_username) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_mysqldb_custom_credentials_config"></a> [mysqldb\_custom\_credentials\_config](#input\_mysqldb\_custom\_credentials\_config) | Specify the configuration settings for MySQL to pass custom credentials during creation | `any` | <pre>{<br>  "custom_user_password": "",<br>  "custom_username": "",<br>  "exporter_password": "",<br>  "exporter_user": "",<br>  "replication_password": "",<br>  "replication_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mysqldb_custom_credentials_enabled"></a> [mysqldb\_custom\_credentials\_enabled](#input\_mysqldb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MySQL database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | n/a | `string` | `""` | no |
| <a name="input_storage_resource_group_name"></a> [storage\_resource\_group\_name](#input\_storage\_resource\_group\_name) | Azure Storage account Resource Group name | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_user_password"></a> [custom\_user\_password](#output\_custom\_user\_password) | custom user's password of mysqldb |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mysqldb\_exporter user's password of mysqldb |
| <a name="output_mysqldb_replication_user_password"></a> [mysqldb\_replication\_user\_password](#output\_mysqldb\_replication\_user\_password) | replicator user's password of mysqldb |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of mysqldb |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
