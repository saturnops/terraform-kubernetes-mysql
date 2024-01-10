## Mysql Example


<br>
This example will be very useful for users who are new to a module and want to quickly learn how to use it. By reviewing the examples, users can gain a better understanding of how the module works, what features it supports, and how to customize it to their specific needs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp"></a> [gcp](#module\_gcp) | saturnops/mysql/kubernetes//modules/resources/gcp | n/a |
| <a name="module_mysql"></a> [mysql](#module\_mysql) | saturnops/mysql/kubernetes | n/a |

## Resources

| Name | Type |
|------|------|
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_credential"></a> [mysql\_credential](#output\_mysql\_credential) | MySQL credentials used for accessing the MySQL database. |
| <a name="output_mysql_endpoints"></a> [mysql\_endpoints](#output\_mysql\_endpoints) | MySQL endpoints in the Kubernetes cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
