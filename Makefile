# Makefile
.PHONY: start stop restart backup clean help

# include .env

help:
	@echo "Available commands:"
	@echo "start    - Start all services"
	@echo "stop     - Stop all services"
	@echo "restart  - Restart all services"
	@echo "backup   - Create backup of configs and volumes"
	@echo "clean    - Remove old backups"

start:
	@./scripts/start.sh

stop:
	@./scripts/stop.sh

restart: stop start

backup:
	@./scripts/backup.sh

clean:
	@./scripts/clean-backups.sh
