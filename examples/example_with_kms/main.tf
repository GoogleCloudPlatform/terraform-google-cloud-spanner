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

resource "google_kms_key_ring" "keyring" {
  project  = var.project_id
  name     = "spanner-keyring1"
  location = "europe-west1"
}

resource "google_kms_crypto_key" "key" {
  name            = "spanner-key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_service_identity" "spanner" {
  provider = google-beta

  project = var.project_id
  service = "spanner.googleapis.com"
}

resource "google_kms_key_ring_iam_member" "key_ring" {
  key_ring_id = google_kms_key_ring.keyring.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${google_project_service_identity.spanner.email}"
}

module "cloud_spanner" {
  source  = "GoogleCloudPlatform/cloud-spanner/google"
  version = "~> 0.1"

  project_id            = var.project_id
  instance_name         = "kms-spanner-name"
  instance_display_name = "kms-spanner-dispname"
  instance_config       = "regional-europe-west1"
  instance_size = {
    num_nodes = 2
    # processing_units = 200

  }
  instance_iam = [
    "user:ashwinknaik@google.com=>roles/spanner.databaseAdmin",
  ]
  instance_labels = {}
  database_config = {
    kmsdb1 = {
      version_retention_period = "3d"
      ddl = [
        "CREATE TABLE t1 (t1 INT64 NOT NULL,) PRIMARY KEY(t1)",
      ]
      deletion_protection = false
      database_iam        = []
      kms_key_name        = google_kms_crypto_key.key.id
      enable_backup       = true
      backup_retention    = 86400
      create_db           = true
    }
  }
  backup_schedule = "0 */6 * * *"

  depends_on = [
    google_kms_key_ring_iam_member.key_ring
  ]
}
