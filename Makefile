.PHONY: help start stop restart status logs

help:
	@echo "Available commands:"
	@echo "  make start SERVICE=<service>"
	@echo "  make stop SERVICE=<service>"
	@echo "  make restart SERVICE=<service>"
	@echo "  make status SERVICE=<service>"
	@echo "  make logs SERVICE=<service>"
	@echo ""
	@echo "Available services:"
	@find compose -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort

start:
	@bash setup.sh $(SERVICE) start

stop:
	@bash setup.sh $(SERVICE) stop

restart:
	@bash setup.sh $(SERVICE) restart

status:
	@bash setup.sh $(SERVICE) status

logs:
	@bash setup.sh $(SERVICE) logs
