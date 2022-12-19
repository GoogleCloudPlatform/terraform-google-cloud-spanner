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
  description = "The Spanner Instance Id."
  value       = module.simple_cloud_spanner.spanner_instance_id
}


output "spanner_db" {
  description = "The Spanner Database details."
  value       = module.simple_cloud_spanner.spanner_db_details[keys(module.simple_cloud_spanner.spanner_db_details)[0]].id
}

output "project_id" {
  description = "GCP Project ID."
  value       = var.project_id
}
