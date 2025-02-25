# terraform-google-cloud-spanner

This module is used to create a [Cloud Spanner](https://cloud.google.com/spanner) Instance.

The resources/services/activations/deletions that this module will create/trigger are:

- Creates a Cloud Spanner Instance
- Creates a Cloud Spanner Database
- Creates a Cloud Spanner Database Backup Scheduler

## Usage

Basic usage of this module is as follows:

```hcl
module "cloud_spanner" {
  source  = "terraform-google-modules/cloud-spanner/google"
  version = "~> 1.0"

  project_id  = "<PROJECT ID>"
  instance_name = "spanner-instance"
  instance_display_name = "Sapnner DEV"
  instance_size = {
    # num_nodes = 2
    processing_units = 200
  }
  instance_config = "regional-europe-west1"
  instance_labels = {
    "key" = "value"
  }
  database_config = {
    db1 = {
      version_retention_period = "3d"
      ddl = [
        "CREATE TABLE t1 (t1 INT64 NOT NULL,) PRIMARY KEY(t1)",
        "CREATE TABLE t2 (t2 INT64 NOT NULL,) PRIMARY KEY(t2)"
      ]
      deletion_protection = false
      database_iam        = []
      enable_backup       = false
      backup_retention    = 86400
      create_db           = true
    }
  }
  backup_schedule = "0 */6 * * *"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_instance | Switch to use create OR use existing Spanner Instance | `bool` | `true` | no |
| cron\_spec\_text | The cron expression for the backup schedule. | `string` | `"0 2 * * *"` | no |
| database\_config | The list of databases with their configuration to be created | <pre>map(object({<br>    version_retention_period = string<br>    ddl                      = list(string)<br>    kms_key_name             = optional(string)<br>    deletion_protection      = bool<br>    database_iam             = list(string)<br>    enable_backup            = optional(bool)<br>    backup_retention         = optional(string)<br>    create_db                = optional(bool)<br>  }))</pre> | <pre>{<br>  "db1": {<br>    "backup_retention": "86400s",<br>    "create_db": true,<br>    "cron_spec_text": "0 2 * * *",<br>    "database_iam": [],<br>    "ddl": [],<br>    "deletion_protection": false,<br>    "enable_backup": true,<br>    "version_retention_period": "3d"<br>  }<br>}</pre> | no |
| default\_backup\_schedule\_type | Default backup schedule type for new databases. | `string` | `"NONE"` | no |
| edition | The edition of the Spanner instance. | `string` | `"STANDARD"` | no |
| enable\_autoscaling | Enable autoscaling for the Spanner Instance | `bool` | `false` | no |
| force\_destroy | Whether to force destroy the instance and its backups. | `bool` | `false` | no |
| high\_priority\_cpu\_utilization\_percent | Target high priority CPU utilization percentage for autoscaling. | `number` | `60` | no |
| instance\_config | The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your databases in this instance. | `string` | `null` | no |
| instance\_display\_name | The descriptive name for this instance as it appears in UIs. | `string` | `"spanner-instance"` | no |
| instance\_iam | The list of permissions on spanner instance | `list(string)` | `[]` | no |
| instance\_labels | A set of key/value label pairs to assign to the spanner instance | `map(string)` | `{}` | no |
| instance\_name | A unique identifier for the instance, which cannot be changed after the instance is created. The name must be between 6 and 30 characters in length. | `string` | `"spanner-instance"` | no |
| instance\_size | The sizing configuration of Spanner Instance based on num of nodes OR instance processing units. | <pre>object({<br>    num_nodes        = optional(number)<br>    processing_units = optional(number)<br>  })</pre> | n/a | yes |
| max\_nodes | Maximum number of nodes for autoscaling. | `number` | `3` | no |
| max\_processing\_units | Maximum number of processing units for autoscaling. | `number` | `3000` | no |
| min\_nodes | Minimum number of nodes for autoscaling. | `number` | `1` | no |
| min\_processing\_units | Minimum number of processing units for autoscaling. | `number` | `1000` | no |
| override\_max\_nodes | Maximum number of nodes for specific replica overrides. | `number` | `3` | no |
| override\_min\_nodes | Minimum number of nodes for specific replica overrides. | `number` | `1` | no |
| project\_id | The project ID to deploy to | `string` | `null` | no |
| replica\_location | Location of the replica for asymmetric autoscaling. | `string` | `"us-central1"` | no |
| storage\_utilization\_percent | Target storage utilization percentage for autoscaling. | `number` | `70` | no |
| use\_full\_backup\_spec | Whether to use full backup specification. | `bool` | `true` | no |
| use\_incremental\_backup\_spec | Whether to use incremental backup specification. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| spanner\_db\_details | Spanner Databases information map |
| spanner\_instance\_id | Spanner Instance ID |
| spanner\_schedule\_backup\_id | Spanner Backup Workflow ID |

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

- Spanner Admin: `roles/spanner.admin`


The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- `iam.googleapis.com`
- `cloudresourcemanager.googleapis.com`
- `storage-api.googleapis.com`
- `serviceusage.googleapis.com`
- `workflows.googleapis.com`
- `cloudscheduler.googleapis.com`
- `spanner.googleapis.com`
- `pubsub.googleapis.com`
- `logging.googleapis.com`
- `storage.googleapis.com`
- `appengine.googleapis.com`
- `cloudkms.googleapis.com`

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
