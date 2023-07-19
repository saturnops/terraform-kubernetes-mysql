#!/bin/bash

set -e

SCRIPT_NAME=backup-mysqldb
ARCHIVE_NAME=mysqldump_$(date +%Y%m%d_%H%M%S).zip

echo "[$SCRIPT_NAME] Dumping all MysqlDB databases to sql..."

mysqldump -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD --flush-logs --add-drop-database --single-transaction \
    --lock-tables=false --events --triggers --routines --ssl-mode=DISABLED --all-databases > full-backup.sql

echo "[$SCRIPT_NAME] Creating compressed archive..."
zip $ARCHIVE_NAME full-backup.sql

if [ "$CLOUD" == "aws" ]; then
  echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
  aws s3 cp "$ARCHIVE_NAME" "$MYSQL_BUCKET_URI"
  echo "[$SCRIPT_NAME] Archive uploaded to S3 bucket."
elif [ "$CLOUD" == "gcp" ]; then
  echo "[$SCRIPT_NAME] Uploading compressed archive to GCS bucket..."
  gcloud container clusters list
  gsutil cp "$ARCHIVE_NAME" "$MYSQL_BUCKET_URI"
  echo "[$SCRIPT_NAME] Archive uploaded to GCS bucket."
else
  echo "[$SCRIPT_NAME] Invalid upload destination specified. Please set 'CLOUD' variable to 'aws' or 'gcp'."
  exit 1
fi

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"
