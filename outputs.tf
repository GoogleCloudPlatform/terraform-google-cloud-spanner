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

output "spanner_instance_id" {
  description = "Spanner Instance ID"
  value = try(
    google_spanner_instance.instance_num_node[0].id,
    google_spanner_instance.instance_processing_units[0].id
  )
}

output "spanner_db_details" {
  description = "Spanner Databases information map"
  value = {
    for db_name, _ in var.database_config :
    db_name => google_spanner_database.database[db_name]
  }
}

output "workflow_id" {
  description = "Spanner Backup Workflow ID"
  value       = length(local.backup_args) > 0 ? module.schedule_spanner_backup[0].workflow_id : null
}

output "cloud_scheduler_id" {
  description = "Spanner Backup Cloud Scheduler ID"
  value       = length(local.backup_args) > 0 ? module.schedule_spanner_backup[0].scheduler_job_id : null
}
