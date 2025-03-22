#!/bin/bash
set -e

# Check if correct number of arguments provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <command> [service]"
    echo "Available commands: start, stop, restart, status, logs, backup"
    echo "Available services:"
    find compose -mindepth 1 -type d -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | sort
    exit 1
fi

SERVICE=$1
COMMAND=$2

echo $COMMAND, $SERVICE
COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"

# Handle nested monitoring services
if [[ $SERVICE == monitoring/* ]]; then
    COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"
fi

# For backup command, service is optional
if [ "$COMMAND" != "backup" ] && [ -z "$SERVICE" ]; then
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
    backup)
        if [ -z "$3" ]; then
            echo "Error: Backup destination not specified"
            echo "Usage: $0 backup <backup_dest> [service]"
            echo "  If service is not provided, backs up all services"
            exit 1
        fi
        if [ -z "$SERVICE" ]; then
            echo "Backing up all services..."
            ./scripts/backup.sh "$3"
        else
            echo "Backing up service: $SERVICE"
            ./scripts/backup.sh "$3" "$SERVICE"
        fi
    ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Available commands: start, stop, restart, status, logs, backup"
        exit 1
    ;;
esac
