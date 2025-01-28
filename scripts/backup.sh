#!/bin/bash
set -e

BACKUP_DEST=$1
DATE=$(date +%Y%m%d_%H%M%S)

if [ -z "$BACKUP_DEST" ]; then
    echo "Error: Backup destination not specified"
    echo "Usage: make backup BACKUP_DEST=/path/to/backup"
    exit 1
fi

mkdir -p "$BACKUP_DEST/$DATE"

for volume in volumes/*; do
    if [ -d "$volume" ]; then
        echo "Backing up $(basename $volume)..."
        tar czf "$BACKUP_DEST/$DATE/$(basename $volume).tar.gz" "$volume"
    fi
done

echo "Backup completed: $BACKUP_DEST/$DATE"