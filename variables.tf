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
  description = "A unique identifier for the instance, which cannot be changed after the instance is created. The name must be between 6 and 30 characters in length."
  type        = string
  default     = "regional-europe-west1"
}

variable "instance_display_name" {
  description = "The descriptive name for this instance as it appears in UIs."
  type        = string
  default     = "regional-europe-west1"
}

variable "instance_config" {
  description = "The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your databases in this instance."
  type        = string
}

variable "instance_size" {
  description = "The sizing configuration of Spanner Instance based on num of nodes OR instance processing units."
  type = object({
    num_nodes        = optional(number)
    processing_units = optional(number)
  })
  validation {
    condition = !(
      try(var.instance_size.num_nodes, null) == null
      &&
      try(var.instance_size.processing_units, null) == null
    )
    error_message = "Either num_nodes OR processing_units information is supported."
  }
}

variable "create_instance" {
  description = "Switch to use create OR use existing Spanner Instance "
  type        = bool
  default     = true
}

variable "instance_iam" {
  description = "The list of permissions on spanner instance"
  type        = list(string)
}

variable "instance_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the spanner instance"
  default     = {}
}

# variable "enable_default_db" {
#   description = "Enable creation of default DB"
#   type        = bool
#   default     = false
# }

variable "database_config" {
  description = "The list of databases with their configuration to be created "
  type = map(object({
    version_retention_period = string
    ddl                      = list(string)
    kms_key_name             = optional(string)
    deletion_protection      = bool
    database_iam             = list(string)
    enable_backup            = optional(bool)
    backup_retention         = optional(number)
  }))
  default = {
    "db1" = {
      version_retention_period = "3d"
      ddl                      = []
      deletion_protection      = false
      database_iam             = []
      enable_backup            = true
      backup_retention         = 86400
    }
  }
}

variable "backup_schedule" {
  description = "The schedule to be enabled on scheduler to trigger spanner DB backup"
  type        = string
  default     = "0 */6 * * *"
}
