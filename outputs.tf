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

output "spanner_instance_id" {
  description = "Spanner Instance ID"
  value = (
    !var.create_instance ?
    data.google_spanner_instance.instance[0].id :
    (
      local.enable_instance_nn ?
      google_spanner_instance.instance_num_node[0].id :
      google_spanner_instance.instance_processing_units[0].id
    )
  )
}

output "spanner_db_details" {
  description = "Spanner Databases information map"
  value = {
    for k, v in local.database_creation_list :
    k => google_spanner_database.database[k]
  }
}

output "env_var" {
  description = "Map of environment variables for Spanner databases with keys as project_id:instance_name:database_name and values as fully qualified database paths"
  value = {
    for k, v in local.database_creation_list :
    "${var.project_id}:${var.instance_name}:${k}" => "projects/${var.project_id}/instances/${var.instance_name}/databases/${k}"
  }
}

output "spanner_schedule_backup_id" {
  description = "Spanner Backup Workflow ID"
  value       = length(local.backup_args) > 0 ? module.schedule_spanner_backup[0].spanner_schedule_backup_id : null
}
