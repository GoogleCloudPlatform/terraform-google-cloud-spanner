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
| backup\_scheduler\_id | Cloud Schedulere ID for scheduling backup job. |
| backup\_workflow\_id | Cloud Workflow ID for backup job. |
| kms\_key\_id | KMS Key ID |
| kms\_keyring\_id | KMS Key ID |
| project\_id | GCP Project ID. |
| spanner\_db | The Spanner Database details. |
| spanner\_instance\_id | The Spanner Instance Id. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
