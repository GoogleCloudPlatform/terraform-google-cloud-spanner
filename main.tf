/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  enable_instance_nn = (
    try(var.instance_size.num_nodes, 0) != null ?
    true : false
  )

  database_creation_list = {
    for k, v in var.database_config :
    k => v if(try(v.create_db, null) == null ? false : v.create_db)
  }

  database_iam = flatten([
    for k, v in var.database_config :
    [
      for x in v.database_iam :
      "${k}|${element(split("=>", x), 0)}|${element(split("=>", x), 1)}"
    ]
  ])

  backup_args = [
    for k, v in var.database_config :
    {
      "backupId" : k,
      "database" : k,
      "expireTime" : v.backup_retention,
      "parent" : var.instance_name
    } if try(v.enable_backup, false)
  ]
}

resource "google_spanner_instance" "instance_num_node" {
  count        = local.enable_instance_nn && var.create_instance ? 1 : 0
  project      = var.project_id
  config       = var.instance_config
  display_name = var.instance_display_name
  name         = var.instance_name
  num_nodes    = var.instance_size.num_nodes
  labels       = var.instance_labels

  dynamic "autoscaling_config" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      autoscaling_limits {
        min_processing_units = var.min_processing_units
        max_processing_units = var.max_processing_units
        min_nodes            = var.min_nodes
        max_nodes            = var.max_nodes
      }
      autoscaling_targets {
        high_priority_cpu_utilization_percent = var.high_priority_cpu_utilization_percent
        storage_utilization_percent           = var.storage_utilization_percent
      }
      asymmetric_autoscaling_options {
        replica_selection {
          location = var.replica_location
        }
        overrides {
          autoscaling_limits {
            min_nodes = var.override_min_nodes
            max_nodes = var.override_max_nodes
          }
        }
      }
    }
  }

  edition                      = var.edition
  default_backup_schedule_type = var.default_backup_schedule_type
  force_destroy                = var.force_destroy
}

resource "google_spanner_instance" "instance_processing_units" {
  count            = !local.enable_instance_nn && var.create_instance ? 1 : 0
  project          = var.project_id
  config           = var.instance_config
  display_name     = var.instance_display_name
  name             = var.instance_name
  processing_units = var.instance_size.processing_units
  labels           = var.instance_labels
}

data "google_spanner_instance" "instance" {
  count   = !var.create_instance ? 1 : 0
  name    = var.instance_name
  project = var.project_id
}

resource "google_spanner_instance_iam_member" "instance" {
  for_each = toset(var.instance_iam)
  instance = (
    !var.create_instance ?
    data.google_spanner_instance.instance[0].name :
    (
      local.enable_instance_nn ?
      google_spanner_instance.instance_num_node[0].name :
      google_spanner_instance.instance_processing_units[0].name
    )
  )
  project = var.project_id
  role = length(split("=>", each.key)) > 1 ? element(split("=>", each.key), 1) : "roles/spanner.databaseAdmin"
  member = length(split("=>", each.key)) > 1 ? element(split("=>", each.key), 0) : each.key
}

resource "google_spanner_database" "database" {
  for_each = local.database_creation_list
  instance = (
    !var.create_instance ?
    data.google_spanner_instance.instance[0].name :
    (
      local.enable_instance_nn ?
      google_spanner_instance.instance_num_node[0].name :
      google_spanner_instance.instance_processing_units[0].name
    )
  )
  project                  = var.project_id
  name                     = each.key
  version_retention_period = each.value.version_retention_period
  ddl                      = each.value.ddl
  deletion_protection      = each.value.deletion_protection

  dynamic "encryption_config" {
    for_each = (
      try(each.value.kms_key_name, null) != null ?
      tolist([each.value.kms_key_name]) :
      []
    )
    content {
      kms_key_name = encryption_config.value
    }
  }

  lifecycle {
    ignore_changes = [
      ddl # added ignore as changes to ddl forces database replacement
    ]
  }
}

resource "google_spanner_database_iam_member" "database" {
  for_each = toset(local.database_iam)
  instance = (
    !var.create_instance ?
    data.google_spanner_instance.instance[0].name :
    (
      local.enable_instance_nn ?
      google_spanner_instance.instance_num_node[0].name :
      google_spanner_instance.instance_processing_units[0].name
    )
  )
  project  = var.project_id
  database = element(split("|", each.key), 0)
  role     = element(split("|", each.key), 2)
  member   = element(split("|", each.key), 1)

  depends_on = [
    google_spanner_database.database
  ]
}

module "schedule_spanner_backup" {
  for_each = { for idx, backup_arg in local.backup_args : idx => backup_arg }

  source                      = "./modules/schedule_spanner_backup"
  project_id                  = var.project_id
  instance_name               = each.value.parent
  database_name               = each.value.database
  retention_duration          = each.value.expireTime
  cron_spec_text              = var.cron_spec_text
  backup_schedule_name        = "backup-schedule-${each.key}"
  use_full_backup_spec        = var.use_full_backup_spec
  use_incremental_backup_spec = var.use_incremental_backup_spec
  depends_on = [
    google_spanner_instance.instance_num_node,
    google_spanner_instance.instance_processing_units,
    google_spanner_database.database
  ]
}
