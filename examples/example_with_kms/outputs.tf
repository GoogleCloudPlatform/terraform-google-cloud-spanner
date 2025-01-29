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
  description = "The spanner_instance_id."
  value       = module.cloud_spanner.spanner_instance_id
}

output "spanner_db_details" {
  description = "The Spanner Database details."
  value       = module.cloud_spanner.spanner_db_details
}

output "backup_id" {
  description = "Backup ID"
  value       = module.cloud_spanner.spanner_schedule_backup_id
}

output "kms_keyring_id" {
  description = "KMS Key ID"
  value       = google_kms_key_ring.keyring.id
}

output "kms_key_id" {
  description = "KMS Key ID"
  value       = google_kms_crypto_key.key.id
}
