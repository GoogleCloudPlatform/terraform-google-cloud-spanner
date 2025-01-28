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

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "instance_name" {
  description = "The name of the Spanner instance"
  type        = string
}

variable "database_name" {
  description = "The name of the Spanner database"
  type        = string
}

variable "backup_schedule_name" {
  description = "The name of the backup schedule"
  type        = string
}

variable "cron_spec_text" {
  description = "The CRON spec text"
  type        = string
}

variable "retention_duration" {
  description = "The duration for which the backup should be retained."
  type        = string
  default     = "604800s" // Example: 7 days
}

variable "use_full_backup_spec" {
  description = "Whether to use full backup specification."
  type        = bool
  default     = true
}

variable "use_incremental_backup_spec" {
  description = "Whether to use incremental backup specification."
  type        = bool
  default     = false
}
