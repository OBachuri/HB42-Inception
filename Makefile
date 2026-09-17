.ONESHELL:
SHELL := /bin/bash

NAME := inception

-include srcs/.env


RM := rm -fr
C_DIR := pwd

USER_LOG 		:= $(shell echo $${SUDO_USER:-$$(whoami)})
DATA_PATH 		:= /home/$(USER_LOG)/data

COMPOSE			:=  DATA_PATH=$(DATA_PATH)  docker compose -f srcs/docker-compose.yml --env-file srcs/.env

VOLUMES    	:= wp_db wp_files v_nginx_cert v_redis v_prometheus_tsd

SECRETS := db_root_password.txt \
           db_admin_password.txt \
           db_wp_user_password.txt \
           wp_admin_password.txt \
           wp_user_password.txt \
		   ftp_user_password.txt \
		   mariadb_exporter_password.txt

SECRETS_DIR := secrets

REQUIRED_FILES := \
	srcs/.env \
	srcs/docker-compose.yml 

SERVICE_COMMANDS := up start stop restart logs log console

ifneq ($(filter $(firstword $(MAKECMDGOALS)),$(SERVICE_COMMANDS)),)
  SERVICE_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(SERVICE_ARGS):;@:)
endif

help:
	@echo "================================================"
	@echo "         Inception - Studying Docker"
	@echo "================================================"

install:
	sudo apt update
	sudo apt upgrade
	sudo apt install openssl -y
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh --dry-run

up: prepare
	$(COMPOSE) up -d --build $(SERVICE_ARGS)
	
start:
	$(COMPOSE) start $(SERVICE_ARGS)

stop:
	$(COMPOSE) stop $(SERVICE_ARGS)

restart:
	$(COMPOSE) restart $(SERVICE_ARGS)

down:
	@$(COMPOSE) down


logs:
	$(COMPOSE) logs -f $(SERVICE_ARGS)

log: logs

console:
	@docker exec -it $(SERVICE_ARGS) bash  

clean:
	@$(COMPOSE) down --rmi all --volumes

fclean f: clean
	@docker run --rm -v $(DATA_PATH):/data debian:bookworm-slim sh -c 'rm -rf /data/*'

re: fclean up

info:
	@echo "================================================"
	@echo "Volumes directory: $(DATA_PATH)"
	@echo "WP database: $(MARIADB_WP_DATABASE)"
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
	@echo "================================================"

prepare:
	@mkdir -p "$(DATA_PATH)"
	@chmod 777 "$(DATA_PATH)" 2>/dev/null || true;
	@for vol in $(VOLUMES); do \
		mkdir -p "$(DATA_PATH)/$$vol"; \
		chmod 777 "$(DATA_PATH)/$$vol" 2>/dev/null || true; \
	done
	@mkdir -p "$(SECRETS_DIR)"
	@for file in $(SECRETS); do \
		if [ ! -f "$(SECRETS_DIR)/$$file" ] || [ ! -s "$(SECRETS_DIR)/$$file" ]; then \
			openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c 1 > "$(SECRETS_DIR)/$$file" ;\
			openssl rand 256 | tr -dc 'a-zA-Z0-9!@#%^*_+'| head -c 31 >> "$(SECRETS_DIR)/$$file" ;\
			echo "Warning: Required file not found or empty: $(SECRETS_DIR)/$$file and was created with random value." ;\
		fi; \
	done

check:
	@for file in $(REQUIRED_FILES); do \
		if [ ! -f "$$file" ]; then \
			echo "Error: required file not found: $$file"; \
			exit 1; \
		fi; \
	done
	@for file in $(SECRETS); do \
		if [ ! -f "$(SECRETS_DIR)/$$file" ]; then \
			echo "Error: required file not found: $(SECRETS_DIR)/$$file"; \
			exit 1; \
		fi; \
	done

	@echo "All required files are present."

.PHONY: install run debug clean fclean help info prepare check console log logs