# Docker Services Management

## Available Services
- calibre
- couchdb
- hoarder
- miniflux
- monitoring/grafana
- monitoring/influxdb-v2
- npm (Nginx Proxy Manager)
- openwebui
- speedtest

## Setup
1. Create the proxy network:
```bash
docker network create proxy
```

2. Make sure all scripts are executable:
```bash
chmod +x setup.sh scripts/*.sh
```

## Usage

### Using Makefile (recommended)
```bash
# Start a service
make start SERVICE=<service>

# Stop a service 
make stop SERVICE=<service>

# Restart a service
make restart SERVICE=<service>

# Check service status
make status SERVICE=<service>

# View service logs
make logs SERVICE=<service>

# Backup a service
make backup SERVICE=<service> BACKUP_DEST=/path/to/backup
```

### Using setup.sh directly
```bash
# Start a service
./setup.sh <service> start

# Stop a service
./setup.sh <service> stop

# Restart a service
./setup.sh <service> restart

# Check service status
./setup.sh <service> status

# View service logs
./setup.sh <service> logs

# Backup a service
./setup.sh <service> backup /path/to/backup
```

Examples:
```bash
# Start Grafana
./setup.sh monitoring/grafana start

# Stop Calibre
./setup.sh calibre stop

# View all available services
./setup.sh
```

## Backup
To backup all volumes:
```bash
./scripts/backup.sh /path/to/backup/destination
```

## Directory Structure
```
.
├── compose/        # Docker compose files
├── volumes/        # Docker volumes
├── configs/        # Configuration files
├── scripts/        # Management scripts
└── secrets/        # Secret files
```
