#!/bin/bash
set -e

# Check if correct number of arguments provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 [service] <command> [backup_dest]"
    echo "Available commands: start, stop, restart, status, logs, backup, update"
    echo "Available services:"
    find compose -mindepth 1 -type d -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | sort
    exit 1
fi

# Correct argument parsing
if [ "$1" == "backup" ]; then
    # Special case: backup command without service
    COMMAND="backup"
    BACKUP_DEST=$2
    SERVICE=""
else
    # Normal case with service
    SERVICE=$1
    COMMAND=$2
    BACKUP_DEST=$3
fi

# For backup command, service is optional
if [ "$COMMAND" == "backup" ]; then
    if [ -z "$BACKUP_DEST" ]; then
        echo "Error: Backup destination not specified"
        echo "Usage: $0 [service] backup <backup_dest>"
        echo "  If service is not provided, backs up all services"
        exit 1
    fi
    if [ -z "$SERVICE" ]; then
        echo "Backing up all services..."
        ./scripts/backup.sh "$BACKUP_DEST"
    else
        echo "Backing up service: $SERVICE"
        ./scripts/backup.sh "$BACKUP_DEST" "$SERVICE"
    fi
    exit 0
fi

echo "Running command '$COMMAND' for service '$SERVICE'"
COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"

# Handle nested monitoring services
if [[ $SERVICE == monitoring/* ]]; then
    COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"
fi

# For non-backup commands, service is required
if [ -z "$SERVICE" ]; then
    echo "Error: Service must be specified for command '$COMMAND'"
    echo "Available services:"
    find compose -mindepth 1 -type d -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | sort
    exit 1
fi

# Validate service exists if specified
if [ -n "$SERVICE" ] && [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: Service '$SERVICE' not found"
    echo "Available services:"
    find compose -mindepth 1 -type d -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | sort
    exit 1
fi

# Execute command
case $COMMAND in
    start)
        echo "Starting $SERVICE..."
        docker compose -f "$COMPOSE_FILE" up -d
    ;;
    stop)
        echo "Stopping $SERVICE..."
        docker compose -f "$COMPOSE_FILE" down
    ;;
    restart)
        echo "Restarting $SERVICE..."
        docker compose -f "$COMPOSE_FILE" restart
    ;;
    status)
        echo "Status of $SERVICE:"
        docker compose -f "$COMPOSE_FILE" ps
    ;;
    logs)
        echo "Showing logs for $SERVICE:"
        docker compose -f "$COMPOSE_FILE" logs -f
    ;;
    ;;
    update)
        echo "Updating $SERVICE..."
        docker compose -f "$COMPOSE_FILE" pull
        docker compose -f "$COMPOSE_FILE" up -d --force-recreate
    ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Available commands: start, stop, restart, status, logs, backup, update"
        exit 1
    ;;
esac
