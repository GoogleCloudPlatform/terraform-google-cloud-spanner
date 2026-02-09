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
}

variable "instance_display_name" {
  description = "The descriptive name for this instance as it appears in UIs."
  type        = string
  default     = "spanner-instance"
}

variable "instance_config" {
  description = "The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your databases in this instance. It determines where your data is stored. Values are typically of the form regional-europe-west1, us-central etc. In order to obtain a valid list please consult the https://cloud.google.com/spanner/docs/instance-configurations"
  type        = string
}


variable "instance_size" {
  description = "The sizing configuration of Spanner Instance based on num of nodes OR instance processing units."
  type = object({
    num_nodes          = optional(number)
    processing_units   = optional(number)
    enable_autoscaling = optional(bool, false)
  })
  validation {
    condition = !(
      try(var.instance_size.num_nodes, null) == null
      &&
      try(var.instance_size.processing_units, null) == null
      && !try(var.instance_size.enable_autoscaling, false)
    )
    error_message = "Either num_nodes OR processing_units OR autoscaling information is supported."
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
  default     = []
}

variable "instance_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the spanner instance"
  default     = {}
}

variable "database_config" {
  description = "The list of databases with their configuration to be created "
  type = map(object({
    version_retention_period = string
    ddl                      = optional(list(string), [])
    kms_key_name             = optional(string)
    deletion_protection      = bool
    database_iam             = optional(map(list(string)), {})
    enable_backup            = optional(bool)
    backup_retention         = optional(string)
    create_db                = optional(bool)
  }))
  default = {
    "db1" = {
      version_retention_period = "3d"
      ddl                      = []
      deletion_protection      = false
      database_iam             = {}
      enable_backup            = true
      backup_retention         = "86400s"
      create_db                = true
    }
  }
}

variable "cron_spec_text" {
  description = "The cron expression for the backup schedule."
  type        = string
  default     = "0 2 * * *" // Example: once a day at 2 AM UTC
}

variable "autoscaling_limits" {
  description = <<EOT
  Minimum number of processing units for autoscaling.
  Maximum number of processing units for autoscaling.
  Minimum number of nodes for autoscaling.
  Maximum number of nodes for autoscaling.
  EOT
  type = object({
    min_processing_units = optional(number, 0)
    max_processing_units = optional(number, 0)
    min_nodes            = optional(number, 0)
    max_nodes            = optional(number, 0)
  })
  nullable = true
}

variable "autoscaling_targets" {
  description = "Targets for autoscaling high priority CPU and storage utilization percentage for autoscaling."
  type = object({
    high_priority_cpu_utilization_percent = optional(number, 60)
    storage_utilization_percent           = optional(number, 70)
  })
  nullable = true
}

variable "asymmetric_autoscaling_options" {
  description = <<EOT
    Location of the replica for asymmetric autoscaling.
    Minimum number of nodes for specific replica overrides.
    Maximum number of nodes for specific replica overrides.
  EOT
  type = object(
    {
      location = optional(string)
      override_autoscaling_limits = optional(object(
        {
          min_nodes = optional(number)
          max_nodes = optional(number)
        }
      ))
    }
  )
  nullable = true
}

variable "edition" {
  description = "The edition of the Spanner instance."
  type        = string
  default     = "STANDARD"
}

variable "default_backup_schedule_type" {
  description = "Default backup schedule type for new databases."
  type        = string
  default     = "NONE"
}

variable "force_destroy" {
  description = "Whether to force destroy the instance and its backups."
  type        = bool
  default     = false
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
