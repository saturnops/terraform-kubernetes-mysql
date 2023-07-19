resource "google_service_account" "mysql_backup" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_backup_name)
  display_name = "Service Account for Mysql Backup"
}

resource "google_project_iam_member" "secretadmin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mysql_backup.email}"
}

resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mysql_backup.email}"
}

resource "google_service_account_iam_member" "pod_identity" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mysqldb/${var.gcp_ksa_backup_name}]"
  service_account_id = google_service_account.mysql_backup.name
}

resource "google_service_account" "mysql_restore" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_restore_name)
  display_name = "Service Account for Mysql restore"
}

resource "google_project_iam_member" "secretadmin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mysql_restore.email}"
}

resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mysql_restore.email}"
}

resource "google_service_account_iam_member" "pod_identity" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mysqldb/${var.gcp_ksa_restore_name}]"
  service_account_id = google_service_account.mysql_restore.name
}

output "service_account_backup" {
  value = google_service_account.mysql_restore.email
  description = "Google Cloud Service Account name for backup"
}

output "service_account_restore" {
  value = google_service_account.mysql_restore.email
  description = "Google Cloud Service Account name for restore"
}