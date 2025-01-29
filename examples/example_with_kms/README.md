# Simple Example

This example illustrates how to use the `cloud-spanner` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backup\_id | Backup ID |
| kms\_key\_id | KMS Key ID |
| kms\_keyring\_id | KMS Key ID |
| spanner\_db\_details | The Spanner Database details. |
| spanner\_instance\_id | The spanner\_instance\_id. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
