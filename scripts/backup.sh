#!/bin/bash
set -e

BACKUP_DEST=$1
DATE=$(date +%Y%m%d_%H%M%S)

if [ -z "$BACKUP_DEST" ]; then
    echo "Error: Backup destination not specified"
    echo "Usage: $0 <backup_dest> [service]"
    echo "  If service is not provided, backs up all services"
    exit 1
fi

# Get list of services to backup
if [ -n "$2" ]; then
    SERVICES=("$2")
else
    SERVICES=($(ls -d compose/*/ | xargs -n 1 basename))
fi

# Create base backup directory
BACKUP_DIR="$BACKUP_DEST/$DATE"
mkdir -p "$BACKUP_DIR"

for SERVICE in "${SERVICES[@]}"; do
    COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo "Warning: Service '$SERVICE' not found"
        continue
    fi
    
    # Create service backup directory
    SERVICE_BACKUP_DIR="$BACKUP_DIR/$SERVICE"
    mkdir -p "$SERVICE_BACKUP_DIR"
    
    echo "Backing up service: $SERVICE"
    
    # Extract and validate volumes from compose file
    VOLUMES=$(yq '.services[].volumes[]' "$COMPOSE_FILE" | grep -v '^null$' | awk -F: '{print $1}' | sort | uniq)
    
    # Backup each volume
    for volume in $VOLUMES; do
        # Skip anonymous volumes (those without a host path)
        if [[ "$volume" =~ ^[^/] ]]; then
            echo "Skipping anonymous volume: $volume"
            continue
        fi
        
        # Validate and backup
        if [ -d "$volume" ]; then
            echo "Backing up $(basename $volume)..."
            tar czf "$SERVICE_BACKUP_DIR/$(basename $volume).tar.gz" -C "$(dirname $volume)" "$(basename $volume)"
        else
            echo "Warning: Volume path $volume does not exist or is not a directory"
        fi
    done
    
    # Backup compose file
    cp "$COMPOSE_FILE" "$SERVICE_BACKUP_DIR/docker-compose.yml"
done

echo "Backup completed: $BACKUP_DIR"
