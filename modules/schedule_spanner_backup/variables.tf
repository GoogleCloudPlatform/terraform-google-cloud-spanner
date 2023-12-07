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

variable "backup_schedule" {
  description = "The Backup Schedule in CRON format"
  type        = string
}

variable "backup_schedule_region" {
  description = "The schedule to be enabled on scheduler to trigger spanner DB backup"
  type        = string
  default     = "us-central1"
}

variable "workflow_argument" {
  description = "The arguments to workflow as JSON encoded"
  type        = map(any)
  default     = {}
}
