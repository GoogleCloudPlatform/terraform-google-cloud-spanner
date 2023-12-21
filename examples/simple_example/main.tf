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


module "cloud_spanner" {
  source  = "GoogleCloudPlatform/cloud-spanner/google"
  version = "~> 0.1"

  project_id            = var.project_id
  instance_name         = "spanner-name"
  instance_display_name = "spanner-dispname"
  instance_config       = "regional-europe-west1"
  instance_size = {
    # num_nodes = 2
    processing_units = 200
  }
  instance_labels = {}
  database_config = {
    db1 = {
      version_retention_period = "3d"
      ddl = [
        "CREATE TABLE t1 (t1 INT64 NOT NULL,t2 INT64 NOT NULL,) PRIMARY KEY(t1)",
      ]
      deletion_protection = false
      database_iam        = []
      enable_backup       = false
      backup_retention    = 86400
      create_db           = true
    }
  }
}
