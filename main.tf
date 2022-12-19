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
  enable_instance_nn = var.instance_size.num_nodes != null ? true : false
  database_iam = flatten([
    for k, v in var.database_config :
    [
      for x in v.database_iam :
      "${k}|${element(split("=>", x), 0)}|${element(split("=>", x), 1)}"
    ]
  ])

  kms_crypto_keys = [
    for k, v in var.database_config :
    v.kms_key_name if try(v.kms_key_name, null) != null
  ]

  kms_key_rings = toset([
    for k in local.kms_crypto_keys :
    join(
      "/",
      slice(split("/", k), 0, length(split("/", k)) - 2)
    )
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
}

resource "google_spanner_instance" "instance_num_node" {
  count        = local.enable_instance_nn && var.create_instance ? 1 : 0
  project      = var.project_id
  config       = var.instance_config
  display_name = var.instance_display_name
  name         = var.instance_name
  num_nodes    = var.instance_size.num_nodes
  labels       = var.instance_labels
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
  role    = element(split("=>", each.key), 1)
  member  = element(split("=>", each.key), 0)
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_key_ring_iam_member" "key_ring" {
  for_each    = local.kms_key_rings
  key_ring_id = each.key
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-spanner.iam.gserviceaccount.com"
}

resource "google_spanner_database" "database" {
  for_each = var.database_config
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

  depends_on = [
    google_kms_key_ring_iam_member.key_ring
  ]
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
  count             = length(local.backup_args) > 0 ? 1 : 0
  source            = "./modules/schedule_spanner_backup"
  project_id        = var.project_id
  backup_schedule   = var.backup_schedule
  workflow_argument = jsonencode(local.backup_args)
}
