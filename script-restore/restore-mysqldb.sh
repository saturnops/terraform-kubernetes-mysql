#!/bin/bash

MYSQL_BUCKET_RESTORE_URI=$MYSQL_BUCKET_RESTORE_URI
RESTORE_FROM=$RESTORE_FROM

if [ "$RESTORE_FROM" = "s3" ]; then
    # Restore from AWS S3
    set -e

    SCRIPT_NAME=restore-mysql
    ARCHIVE_NAME="$RESTORE_FILE_NAME"

    echo "[$SCRIPT_NAME] DOWNLOADING compressed archive FROM S3 bucket..."
    aws s3 cp "$MYSQL_BUCKET_RESTORE_URI" /scripts
    unzip /scripts/"$RESTORE_FILE_NAME"

    echo "[$SCRIPT_NAME] Restoring all MysqlDB databases from compressed archive..."

    mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD < /scripts/full-backup.sql

    echo "[$SCRIPT_NAME] Restore complete!"

elif [ "$RESTORE_FROM" = "gcs" ]; then
    # Restore from GCP GCS
    set -e

    SCRIPT_NAME=restore-mysql
    ARCHIVE_NAME="$RESTORE_FILE_NAME"

    echo "[$SCRIPT_NAME] DOWNLOADING compressed archive FROM GCS bucket..."
    gsutil cp "$MYSQL_BUCKET_RESTORE_URI" /scripts
    unzip /scripts/"$RESTORE_FILE_NAME"

    echo "[$SCRIPT_NAME] Restoring all MysqlDB databases from compressed archive..."

    mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD < /scripts/full-backup.sql

    echo "[$SCRIPT_NAME] Restore complete!"

else
    echo "Invalid value for RESTORE_FROM variable. It should be 's3' or 'gcs'."
fi
