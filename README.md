# terraform-google-cloud-spanner

This module was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template/), which by default generates a module that simply creates a GCS bucket. As the module develops, this README should be updated.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a GCS bucket with the provided name

## Usage

Basic usage of this module is as follows:

```hcl
module "cloud_spanner" {
  source  = "terraform-google-modules/cloud-spanner/google"
  version = "~> 0.1"

  project_id  = "<PROJECT ID>"
  bucket_name = "gcs-test-bucket"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_schedule | The schedule to be enabled on scheduler to trigger spanner DB backup | `string` | `"0 */6 * * *"` | no |
| create\_instance | Switch to use create OR use existing Spanner Instance | `bool` | `true` | no |
| database\_config | The list of databases with their configuration to be created | <pre>map(object({<br>    version_retention_period = string<br>    ddl                      = list(string)<br>    kms_key_name             = optional(string)<br>    deletion_protection      = bool<br>    database_iam             = list(string)<br>    enable_backup            = optional(bool)<br>    backup_retention         = optional(number)<br>    create_db                = optional(bool)<br>  }))</pre> | <pre>{<br>  "db1": {<br>    "backup_retention": 86400,<br>    "create_db": true,<br>    "database_iam": [],<br>    "ddl": [],<br>    "deletion_protection": false,<br>    "enable_backup": true,<br>    "version_retention_period": "3d"<br>  }<br>}</pre> | no |
| instance\_config | The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your databases in this instance. | `string` | n/a | yes |
| instance\_display\_name | The descriptive name for this instance as it appears in UIs. | `string` | `"regional-europe-west1"` | no |
| instance\_iam | The list of permissions on spanner instance | `list(string)` | n/a | yes |
| instance\_labels | A set of key/value label pairs to assign to the spanner instance | `map(string)` | `{}` | no |
| instance\_name | A unique identifier for the instance, which cannot be changed after the instance is created. The name must be between 6 and 30 characters in length. | `string` | `"regional-europe-west1"` | no |
| instance\_size | The sizing configuration of Spanner Instance based on num of nodes OR instance processing units. | <pre>object({<br>    num_nodes        = optional(number)<br>    processing_units = optional(number)<br>  })</pre> | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| spanner\_db\_details | Spanner Databases information map |
| spanner\_instance\_id | Spanner Instance ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
