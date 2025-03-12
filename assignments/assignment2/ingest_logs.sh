#!/bin/bash

# Usage check: make sure a date parameter is provided in YYYY-MM-DD format.
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <YYYY-MM-DD>"
  exit 1
fi

DATE="$1"

# Validate the date format (YYYY-MM-DD)
if [[ ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "Error: Date must be in YYYY-MM-DD format."
  exit 1
fi

# Parse year, month, and day from the provided date.
YEAR=$(echo "$DATE" | cut -d'-' -f1)
MONTH=$(echo "$DATE" | cut -d'-' -f2)
DAY=$(echo "$DATE" | cut -d'-' -f3)

# Define the target HDFS directories for logs and metadata.
HDFS_LOGS_DIR="/raw/logs/$YEAR/$MONTH/$DAY"
HDFS_METADATA_DIR="/raw/metadata/$YEAR/$MONTH/$DAY"

# Create the target directories in HDFS (if they do not already exist).
hdfs dfs -mkdir -p "$HDFS_LOGS_DIR"
hdfs dfs -mkdir -p "$HDFS_METADATA_DIR"

# Copy the local files into the corresponding HDFS directories.
hdfs dfs -put user_activity_logs "$HDFS_LOGS_DIR/"
hdfs dfs -put content_metadata "$HDFS_METADATA_DIR/"

echo "Ingestion complete for date $DATE. Files have been copied to:"
echo "Logs: $HDFS_LOGS_DIR"
echo "Metadata: $HDFS_METADATA_DIR"
