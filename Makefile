.PHONY: help start stop restart status logs backup update

help:
	@echo "Available commands:"
	@echo "  make start SERVICE=<service>"
	@echo "  make stop SERVICE=<service>"
	@echo "  make restart SERVICE=<service>"
	@echo "  make status SERVICE=<service>"
	@echo "  make logs SERVICE=<service>"
	@echo "  make backup SERVICE=<service|all> BACKUP_DEST=/path/to/backup"
	@echo "  make update SERVICE=<service>"
	@echo ""
	@echo "Available services:"
	@find compose -mindepth 1 -type f -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | sort

start:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh start $(SERVICE)

stop:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh stop $(SERVICE)

restart:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh restart $(SERVICE)

status:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh status $(SERVICE)

logs:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh logs $(SERVICE)

backup:
	@if [ -z "$(BACKUP_DEST)" ]; then \
		echo "Error: BACKUP_DEST must be specified"; \
		exit 1; \
	fi
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified (use 'all' for all services)"; \
		exit 1; \
	fi
	@bash setup.sh backup $(SERVICE) $(BACKUP_DEST)

update:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@bash setup.sh update $(SERVICE)
