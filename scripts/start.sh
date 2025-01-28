#!/bin/bash
set -e

echo "Starting services..."
find compose -name "docker-compose.yml" -print0 | while IFS= read -r -d $'\0' compose_file; do
    docker compose -f "$compose_file" up -d
done