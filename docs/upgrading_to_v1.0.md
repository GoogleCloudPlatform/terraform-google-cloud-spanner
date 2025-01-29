# Upgrading to v1.0
The v1.0 release of *cloud-spanner* is a backwards incompatible
release.

### Google Cloud Platform Provider upgrade
The Terraform Cloud Spanner Module now requires version 6.1 or higher of the Google Cloud Platform Providers.

### Backup Module Output Changes
The Terraform Cloud Spanner Backup Module now outputs the `spanner_schedule_backup_id` instead of `workflow_id` and `scheduler_job_id`.:

```diff
-  output "workflow_id" {
-  description = "The id  of the workflow."
-  value       = module.workflow.workflow_id
- }
-
- output "scheduler_job_id" {
-  description = "Google Cloud scheduler job id"
-  value       = module.workflow.scheduler_job_id
+ output "spanner_schedule_backup_id" {
+  description = "Spanner Schedule Backup ID"
+  value       = google_spanner_backup_schedule.backup_schedule.id
}
```

you must now specify `database_name`, `backup_schedule_name`, `cron_spec_text`, `retention_duration`, `use_full_backup_spec` and `use_incremental_backup_spec` instead of `backup_schedule`, `backup_schedule_region` and `workflow_argument`.
