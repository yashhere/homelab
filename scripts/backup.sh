#!/bin/bash
set -e

SERVICE=$1
BACKUP_DEST=$2
DATE=$(date +%Y%m%d_%H%M%S)

if [ -z "$BACKUP_DEST" ]; then
    echo "Error: Backup destination not specified"
    echo "Usage: $0 <service> <backup_dest>"
    exit 1
fi

# Get volume paths from compose file
COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: Service '$SERVICE' not found"
    exit 1
fi

# Create backup directory
BACKUP_DIR="$BACKUP_DEST/$SERVICE/$DATE"
mkdir -p "$BACKUP_DIR"

echo $BACKUP_DIR
# Extract volumes from compose file
VOLUMES=$(yq '.services[].volumes[]' "$COMPOSE_FILE" | grep -v '^null$' | awk -F: '{print $1}' | sort | uniq)

echo $VOLUMES

# Backup each volume
for volume in $VOLUMES; do
    echo "$volume"
    if [ -d "$volume" ]; then
        echo "Backing up $(basename $volume)..."
        tar czf "$BACKUP_DIR/$(basename $volume).tar.gz" "$volume"
    fi
done

# Backup compose file
cp "$COMPOSE_FILE" "$BACKUP_DIR/docker-compose.yml"

echo "Backup completed: $BACKUP_DIR"
