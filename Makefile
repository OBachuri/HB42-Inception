.ONESHELL:
SHELL := /bin/bash

NAME        = inception

RM = rm -fr
C_DIR := pwd

USER_LOG 		:= $(shell echo $${SUDO_USER:-$$(whoami)})
DATA_PATH 		= /home/$(USER_LOG)/data

COMPOSE			:= DATA_PATH=$(DATA_PATH) docker compose -f srcs/docker-compose.yml
SERVICE_ARGS	:= ""

help:
	@echo "================================================"
	@echo "         Inception - Studying Docker"
	@echo "================================================"

install:
	sudo apt update
	sudo apt upgrade
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh --dry-run

up:
	$(COMPOSE) up -d --build $(SERVICE_ARGS)
	
start:
	$(COMPOSE) start $(SERVICE_ARGS)

stop:
	$(COMPOSE) stop $(SERVICE_ARGS)

restart:
	$(COMPOSE) restart $(SERVICE_ARGS)

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f $(SERVICE_ARGS)

clean:
	$(COMPOSE) down --rmi all --volumes

info:
	@echo "================== CONTAINERS =================="
	@docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"

	@echo ""
	@echo "==================== IMAGES ===================="
	@docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"

	@echo ""
	@echo "==================== VOLUMES ==================="
	@docker volume ls

	@echo ""
	@echo "==================== NETWORKS =================="
	@docker network ls

	@echo ""
	@echo "==================== DISK USAGE ================"
	@docker system df

	@echo ""
	@echo "==================== PROJECT ==================="
	@$(COMPOSE) ps -a


.PHONY: install run debug clean help info