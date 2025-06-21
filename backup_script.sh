#!/bin/bash

# Configration

# project and backup folder paths from CLI
PROJECT_FOLDER="$1"
BACKUP_DIR="$2"

# retention period

# backup for the last 7 days
DAILY_RETENTION=${DAILY_RETENTION:-7}

# backup for last 4 sundays means 28 days
WEEKLY_RETENTION=${WEEKLY_RETENTION:-28}

# backup for last 3 months means 90 days
MONTHLY_RETENTION=${MONTHLY_RETENTION:-90}

# remote drive name and folder name
REMOTE_NAME="enacton"
REMOTE_FOLDER="ansible-playbook"

# enabling the curl request for the notification
ENABLE_CURL=${ENABLE_CURL:-true}

# for passing the notification to specific webhook url
WEBHOOK_URL="https://webhook.site/https://webhook.site/677404ea-d467-43b3-8db6-c8e91395d596"

# project name 
PROJECT_NAME="ansible-playbook"

# validation -> for checking if args are passed or not!
# -z for checking empty string
if [ -z "$PROJECT_FOLDER" ] || [ -z "$BACKUP_DIR" ]; then
  echo "Please pass both the project folder and backup folder path!!!"
  exit 1
fi

# -d for checking the existance of directory
if [ ! -d "$PROJECT_FOLDER" ]; then
  echo "project folder '$PROJECT_FOLDER' does not exist."
  exit 1
fi

# setting up the time for the file naming
DATE=$(date +'%Y-%m-%d')
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')

# full file name with the timestamp
BACKUP_NAME="${PROJECT_NAME}_${TIMESTAMP}.zip"

# backup directoory path for local backup 
DAILY_FOLDER="${BACKUP_DIR}/daily"
WEEKLY_FOLDER="${BACKUP_DIR}/weekly"
MONTHLY_FOLDER="${BACKUP_DIR}/monthly"

# log file path 
LOG_FILE="${BACKUP_DIR}/backup.log"

# creates folder if it does not exist
mkdir -p "$DAILY_FOLDER" "$WEEKLY_FOLDER" "$MONTHLY_FOLDER"

# pulling the github repo to the local machine
if [ -d "$PROJECT_FOLDER/.git" ]; then
  echo "pulling the latest changes!"
  cd "$PROJECT_FOLDER" || exit 1
  git pull origin main || git pull origin master

else
  echo "No Git repository found in $PROJECT_FOLDER!!!!"
fi

# Zip file creation on folder named daily
ZIP_PATH="$DAILY_FOLDER/$BACKUP_NAME"
echo "Creating backup zip file at: $ZIP_PATH"

# here -r means recursive tells to include all files and subddirectories 
zip -r "$ZIP_PATH" "$PROJECT_FOLDER" > /dev/null
if [ $? -ne 0 ]; then

# here tee means writes the output and -a for appending the message into log file
  echo "Backup zip creation failed." | tee -a "$LOG_FILE"
  exit 1
fi
# daily backup
cp "$ZIP_PATH" "$DAILY_FOLDER/$BACKUP_NAME"

# copy the task to the montly and weekly folder if applicable 
DAY_OF_WEEK=$(date +%u)   # return day of week 1-7
DAY_OF_MONTH=$(date +%d)  # return day of month 1-31

if [ "$DAY_OF_WEEK" -eq 7 ]; then
  cp "$ZIP_PATH" "$WEEKLY_FOLDER/$BACKUP_NAME"
fi

if [ "$DAY_OF_MONTH" -eq 1 ]; then
  cp "$ZIP_PATH" "$MONTHLY_FOLDER/$BACKUP_NAME"
fi

# Backup upload on Google Drive
echo "Uploading backup to Google Drive..."
rclone copy "$ZIP_PATH" "${REMOTE_NAME}:${REMOTE_FOLDER}/daily/" --quiet
[ "$DAY_OF_WEEK" -eq 7 ] && rclone copy "$ZIP_PATH" "${REMOTE_NAME}:${REMOTE_FOLDER}/weekly/" --quiet
[ "$DAY_OF_MONTH" -eq 01 ] && rclone copy "$ZIP_PATH" "${REMOTE_NAME}:${REMOTE_FOLDER}/monthly/" --quiet

#DELETION

# Local rotation
echo "Cleaning old local backup files..."

find "$DAILY_FOLDER" -type f -name "*.zip" -mtime +$DAILY_RETENTION -delete
find "$WEEKLY_FOLDER" -type f -name "*.zip" -mtime +$WEEKLY_RETENTION -delete
find "$MONTHLY_FOLDER" -type f -name "*.zip" -mtime +$MONTHLY_RETENTION -delete

# drive rotation
echo "cleaning old backup files from drive if exist!!!"
rclone ls "${REMOTE_NAME}:${REMOTE_FOLDER}/daily/" &> /dev/null && \
  rclone delete --min-age ${DAILY_RETENTION}d "${REMOTE_NAME}:${REMOTE_FOLDER}/daily/" --quiet

rclone ls "${REMOTE_NAME}:${REMOTE_FOLDER}/weekly/" &> /dev/null && \
  rclone delete --min-age ${WEEKLY_RETENTION}d "${REMOTE_NAME}:${REMOTE_FOLDER}/weekly/" --quiet

rclone ls "${REMOTE_NAME}:${REMOTE_FOLDER}/monthly/" &> /dev/null && \
  rclone delete --min-age ${MONTHLY_RETENTION}d "${REMOTE_NAME}:${REMOTE_FOLDER}/monthly/" --quiet

# adding logs to the logifle 
echo "[$(date)] Backup created and uploaded: $BACKUP_NAME" >> "$LOG_FILE"

# curl notification
if [ "$ENABLE_CURL" = true ]; then
  echo "notification to webhook"
  curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"project\": \"$PROJECT_NAME\", \"date\": \"$TIMESTAMP\", \"status\": \"BackupSuccessful\"}" \
  "$WEBHOOK_URL" > /dev/null
fi

echo "Yessss, Backup completed successfully: $BACKUP_NAME"
