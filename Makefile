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
		echo "Starting all services..."; \
		find compose -mindepth 1 -type f -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | xargs -I {} bash setup.sh start {}; \
	else \
		echo "Starting services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			bash setup.sh start $$svc; \
		done \
	fi

stop:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Stopping all services..."; \
		find compose -mindepth 1 -type f -name "docker-compose.yml" -exec dirname {} \; | sed 's|^compose/||' | xargs -I {} bash setup.sh stop {}; \
	else \
		echo "Stopping services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			bash setup.sh stop $$svc; \
		done \
	fi

restart:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@echo "Restarting services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			bash setup.sh restart $$svc; \
		done

status:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@echo "Getting status for services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			echo "--- Status for $$svc ---"; \
			bash setup.sh status $$svc; \
		done

logs:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@echo "Getting logs for services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			echo "--- Logs for $$svc ---"; \
			bash setup.sh logs $$svc; \
		done

backup:
	@if [ -z "$(BACKUP_DEST)" ]; then \
		echo "Error: BACKUP_DEST must be specified"; \
		exit 1; \
	fi
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified (use 'all' for all services)"; \
		exit 1; \
	fi
	@if [ "$(SERVICE)" = "all" ]; then \
			echo "Backing up all services to $(BACKUP_DEST)..."; \
			bash setup.sh backup all $(BACKUP_DEST); \
		else \
			echo "Backing up services: $(SERVICE) to $(BACKUP_DEST)..."; \
			for svc in $(SERVICE); do \
				bash setup.sh backup $$svc $(BACKUP_DEST); \
			done; \
		fi

update:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE must be specified"; \
		exit 1; \
	fi
	@echo "Updating services: $(SERVICE)"; \
		for svc in $(SERVICE); do \
			bash setup.sh update $$svc; \
		done
