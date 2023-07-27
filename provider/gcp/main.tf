resource "google_secret_manager_secret" "mysql-secret" {
  project   = var.project_id
  secret_id = format("%s-%s-%s", var.mysqldb_config.environment, var.mysqldb_config.name, "mysql")

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mysql-secret" {
  secret      = google_secret_manager_secret.mysql-secret.id
  secret_data = <<EOF
   {
    "root_user": "root",
    "root_password": "${var.root_password}",
    "custom_username": "${var.mysqldb_config.custom_user_username}",
    "custom_user_password": "${var.custom_user_password}",
    "replication_user": "replicator",
    "replication_password": "${var.replication_password}",
    "exporter_user": "mysqld_exporter",
    "exporter_password": "${var.exporter_password}"
   }
EOF
}

resource "google_service_account" "mysql_backup" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_backup_name)
  display_name = "Service Account for Mysql Backup"
}

resource "google_project_iam_member" "secretadmin_backup" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mysql_backup.email}"
}

resource "google_project_iam_member" "service_account_token_creator_backup" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mysql_backup.email}"
}

resource "google_service_account_iam_member" "pod_identity_backup" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mysqldb/${var.gcp_ksa_backup_name}]"
  service_account_id = google_service_account.mysql_backup.name
}

resource "google_service_account" "mysql_restore" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_restore_name)
  display_name = "Service Account for Mysql restore"
}

resource "google_project_iam_member" "secretadmin_restore" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mysql_restore.email}"
}

resource "google_project_iam_member" "service_account_token_creator_restore" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mysql_restore.email}"
}

resource "google_service_account_iam_member" "pod_identity_restore" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mysqldb/${var.gcp_ksa_restore_name}]"
  service_account_id = google_service_account.mysql_restore.name
}

output "service_account_backup" {
  value       = google_service_account.mysql_backup.email
  description = "Google Cloud Service Account name for backup"
}

output "service_account_restore" {
  value       = google_service_account.mysql_restore.email
  description = "Google Cloud Service Account name for restore"
}
