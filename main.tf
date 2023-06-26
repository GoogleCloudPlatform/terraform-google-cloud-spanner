/**
 * Copyright 2023 Google LLC
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
      "database" : "projects/${var.project_id}/instances/${var.instance_name}/databases/${k}",
      "expireTime" : v.backup_retention,
      "parent" : "projects/${var.project_id}/instances/${var.instance_name}"
    } if try(v.enable_backup, false)
  ]

  instance_bindings_in_object = flatten([
    for role, members in var.instance_iam : [for member in members : { role = role, member = member }]
  ])

  instance_bindings_iteratable = { for binding in local.instance_bindings_in_object : "${binding.role}--${binding.member}" => binding }
}

resource "google_spanner_instance" "instance_num_node" {
  count        = lookup(var.instance_size, "num_nodes", null) != null ? 1 : 0
  project      = var.project_id
  config       = var.instance_config
  display_name = var.instance_display_name
  name         = var.instance_name
  num_nodes    = lookup(var.instance_size, "num_nodes")
  labels       = var.instance_labels
}

resource "google_spanner_instance" "instance_processing_units" {
  count            = lookup(var.instance_size, "processing_units", null) != null ? 1 : 0
  project          = var.project_id
  config           = var.instance_config
  display_name     = var.instance_display_name
  name             = var.instance_name
  processing_units = lookup(var.instance_size, "processing_units")
  labels           = var.instance_labels
}

resource "google_spanner_instance_iam_member" "instance" {
  for_each = local.instance_bindings_iteratable
  instance = try(
    google_spanner_instance.instance_num_node[0].name,
    google_spanner_instance.instance_processing_units[0].name
  )
  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}

resource "google_spanner_database" "database" {
  for_each = var.database_config
  instance = try(
    google_spanner_instance.instance_num_node[0].name,
    google_spanner_instance.instance_processing_units[0].name
  )
  project                  = var.project_id
  name                     = each.key
  version_retention_period = each.value.version_retention_period
  ddl                      = each.value.ddl
  deletion_protection      = each.value.deletion_protection

  dynamic "encryption_config" {
    for_each = lookup(each.value, "kms_key_name", null) != null ? [true] : []
    content {
      kms_key_name = lookup(each.value, "kms_key_name", null)
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
  instance = try(
    google_spanner_instance.instance_num_node[0].name,
    google_spanner_instance.instance_processing_units[0].name
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
  count                  = length(local.backup_args) > 0 ? 1 : 0
  source                 = "./modules/schedule_spanner_backup"
  project_id             = var.project_id
  backup_schedule        = var.backup_schedule
  workflow_argument      = jsonencode(local.backup_args)
  backup_schedule_region = var.backup_schedule_region
}
