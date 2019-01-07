#!/bin/bash -e

CONTEXT="$1"
BACKUP_DIR="$2"
DRY_RUN="$3"

NOW=$(date +"%Y_%m_%d-%H_%M")
BACKUP_FILENAME="$CONTEXT-$NOW.sql.gz"
BACKUP_FILE_FULLPATH="$BACKUP_DIR/$BACKUP_FILENAME"
DB_NAME="shipdb"

check_params() {
  echo "Checking params"
  if [ "$CONTEXT" == "" ]; then
    echo "CONTEXT is required";
    exit 99;
  fi

  if [ "$BACKUP_DIR" == "" ]; then
    echo "BACKUP_DIR is required";
    exit 99;
  fi
}

log_context() {
  echo "CONTEXT: $CONTEXT"
  echo "BACKUP_DIR: $BACKUP_DIR"
  echo "BACKUP_FILE_FULLPATH: $BACKUP_FILE_FULLPATH"
  echo "DB_NAME: $DB_NAME"
}

create_backup() {
  echo "Creating backup at $BACKUP_FILE_FULLPATH"
  time sudo su postgres bash -c "pg_dump -d $DB_NAME | gzip > $BACKUP_FILE_FULLPATH"
}

cleanup() {
  echo "Deleting local backup files at $BACKUP_DIR"
  # Uses sudo because the file is owned by postgres
  sudo rm -f "$BACKUP_DIR"/*.sql.gz
}

main() {
  check_params
  log_context
  if [ "$DRY_RUN" == true ]; then
    echo "This is a dry run. Exiting early."
    exit 0;
  fi
  cleanup
  create_backup
}

main
