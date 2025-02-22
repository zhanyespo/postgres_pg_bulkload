#!/bin/bash

# PostgreSQL database and user configuration
DB_NAME="postgres"
DB_USER="postgres"

# Paths inside the container
CSV_DIR="/csv_files"
CTL_DIR="/ctl_files"
LOG_DIR="/logs"

# Function to run pg_bulkload with a control file
run_bulkload_with_ctl() {
    CTL_FILE=$1
    TABLE_NAME=$2
    LOG_FILE="$LOG_DIR/${TABLE_NAME}_bulkload.log"

    echo "Loading $TABLE_NAME using $CTL_FILE..."
    pg_bulkload $CTL_FILE -d $DB_NAME -U $DB_USER -l $LOG_FILE

    if [ $? -eq 0 ]; then
        echo "Successfully loaded $TABLE_NAME"
    else
        echo "Failed to load $TABLE_NAME. Check log: $LOG_FILE"
    fi
}

# Load authors.csv using authors.ctl
run_bulkload_with_ctl "$CTL_DIR/authors.ctl" "authors"

# Load authors.csv using authors.ctl
run_bulkload_with_ctl "$CTL_DIR/comments.ctl" "comments"

# Load authors.csv using authors.ctl
run_bulkload_with_ctl "$CTL_DIR/submissions.ctl" "submissions"

# Load authors.csv using authors.ctl
run_bulkload_with_ctl "$CTL_DIR/subreddits.ctl" "subreddits"

# pg_bulkload /ctl_files/submissions.ctl -d postgres -U postgres -l /logs/submissions_bulkload.log

# pg_bulkload /ctl_files/subreddits.ctl -d postgres -U postgres -l /logs/subreddits_bulkload.log