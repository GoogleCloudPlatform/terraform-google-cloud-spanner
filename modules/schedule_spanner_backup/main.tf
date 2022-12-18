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

module "service_account_scheduler" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.1.1"
  project_id = var.project_id
  prefix     = "spanner-backup-scheduler"
  names      = ["1"]

  project_roles = ["${var.project_id}=>roles/workflows.invoker"]
}

module "service_account_workflow" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 4.1.1"
  project_id    = var.project_id
  prefix        = "spanner-backup-workflow"
  names         = ["1"]
  project_roles = ["${var.project_id}=>roles/spanner.backupAdmin"]
}

module "workflow" {
  source                 = "github.com/GoogleCloudPlatform/terraform-google-cloud-workflows?ref=main"
  project_id             = var.project_id
  workflow_name          = "spanner-backup-workflow"
  region                 = var.backup_schedule_region
  service_account_email  = module.service_account_workflow.email
  service_account_create = false

  workflow_trigger = {
    cloud_scheduler = {
      name                  = "spanner-backup-job"
      cron                  = var.backup_schedule
      time_zone             = "America/New_York"
      deadline              = "320s"
      service_account_email = module.service_account_scheduler.email
      argument              = var.workflow_argument
    }
  }
  workflow_source = file("${path.module}/spanner_backup.yml")

  depends_on = [
    module.service_account_scheduler,
    module.service_account_workflow
  ]
}
