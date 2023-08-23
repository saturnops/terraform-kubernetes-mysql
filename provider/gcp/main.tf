resource "random_password" "mysqldb_root_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_custom_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_replication_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mysqldb_exporter_user_password" {
  count   = var.mysqldb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "google_secret_manager_secret" "mysql-secret" {
  count     = var.store_password_to_secret_manager ? 1 : 0
  project   = var.project_id
  secret_id = format("%s-%s-%s", var.environment, var.name, "mysql")

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mysql-secret" {
  count  = var.store_password_to_secret_manager ? 1 : 0
  secret = google_secret_manager_secret.mysql-secret[0].id
  secret_data = var.mysqldb_custom_credentials_enabled ? jsonencode(
    {
      "root_user" : "${var.mysqldb_custom_credentials_config.root_user}",
      "root_password" : "${var.mysqldb_custom_credentials_config.root_password}",
      "custom_username" : "${var.mysqldb_custom_credentials_config.custom_username}",
      "custom_user_password" : "${var.mysqldb_custom_credentials_config.custom_user_password}",
      "replication_user" : "${var.mysqldb_custom_credentials_config.replication_user}",
      "replication_password" : "${var.mysqldb_custom_credentials_config.replication_password}",
      "exporter_user" : "${var.mysqldb_custom_credentials_config.exporter_user}",
      "exporter_password" : "${var.mysqldb_custom_credentials_config.exporter_password}"
    }) : jsonencode(
    {
      "root_user" : "root",
      "root_password" : "${random_password.mysqldb_root_password[0].result}",
      "custom_username" : "${var.custom_user_username}",
      "custom_user_password" : "${random_password.mysqldb_custom_user_password[0].result}",
      "replication_user" : "replicator",
      "replication_password" : "${random_password.mysqldb_replication_user_password[0].result}",
      "exporter_user" : "mysqld_exporter",
      "exporter_password" : "${random_password.mysqldb_exporter_user_password[0].result}"
  })
}

resource "google_service_account" "mysql_backup" {
  project      = var.project_id
  account_id   = format("%s-%s-%s", var.environment, var.gcp_gsa_backup_name, var.name)
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
  account_id   = format("%s-%s-%s", var.environment, var.gcp_gsa_restore_name, var.name)
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
