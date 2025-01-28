#!/bin/bash
set -e

echo "Stopping services..."
for compose_file in compose/*/docker-compose.yml; do
    docker compose -f "$compose_file" down
done