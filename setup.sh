#!/bin/bash
set -e

# Check if correct number of arguments provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <service> <command>"
    echo "Available services:"
    find compose -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
    exit 1
fi

SERVICE=$1
COMMAND=$2
COMPOSE_FILE="compose/$SERVICE/docker-compose.yml"

# Validate service exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: Service '$SERVICE' not found"
    echo "Available services:"
    find compose -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
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
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Available commands: start, stop, restart, status, logs"
        exit 1
    ;;
esac
