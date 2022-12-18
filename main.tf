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
}

resource "google_spanner_instance" "instance_num_node" {
  count        = local.enable_instance_nn ? 1 : 0
  project      = var.project_id
  config       = var.instance_config
  display_name = var.instance_display_name
  name         = var.instance_name
  num_nodes    = var.instance_size.num_nodes
  labels       = var.instance_labels
}

resource "google_spanner_instance" "instance_processing_units" {
  count            = local.enable_instance_nn ? 0 : 1
  project          = var.project_id
  config           = var.instance_config
  display_name     = var.instance_display_name
  name             = var.instance_name
  processing_units = var.instance_size.processing_units
  labels           = var.instance_labels
}

resource "google_spanner_instance_iam_member" "instance" {
  for_each = toset(var.instance_iam)
  instance = (
    local.enable_instance_nn ?
    google_spanner_instance.instance_num_node[0].name :
    google_spanner_instance.instance_processing_units[0].name
  )
  project = var.project_id
  role    = element(split("=>", each.key), 1)
  member  = element(split("=>", each.key), 0)
}

resource "google_spanner_database" "database" {
  for_each = var.database_config
  instance = (
    local.enable_instance_nn ?
    google_spanner_instance.instance_num_node[0].name :
    google_spanner_instance.instance_processing_units[0].name
  )
  project                  = var.project_id
  name                     = each.key
  version_retention_period = each.value.version_retention_period
  ddl                      = each.value.ddl
  deletion_protection      = each.value.deletion_protection
}

resource "google_spanner_database_iam_member" "database" {
  for_each = toset(local.database_iam)
  instance = (
    local.enable_instance_nn ?
    google_spanner_instance.instance_num_node[0].name :
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