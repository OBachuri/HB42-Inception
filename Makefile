.ONESHELL:
SHELL := /bin/bash

NAME := inception

-include srcs/.env


RM := rm -fr
C_DIR := pwd

USER_LOG 		:= $(shell echo $${SUDO_USER:-$$(whoami)})
DATA_PATH 		:= /home/$(USER_LOG)/data

COMPOSE			:= docker compose -f srcs/docker-compose.yml

VOLUMES    	:= wp_db wp_files

SECRETS := db_root_password.txt \
           db_admin_password.txt \
           db_wp_user_password.txt \
           wp_admin_password.txt \
           wp_user_password.txt

SECRETS_DIR := secrets

REQUIRED_FILES := \
	srcs/.env \
	srcs/docker-compose.yml 

SERVICE_COMMANDS := up start stop restart logs

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

fclean f: clean
	# Even with Rootless Docker if you have access to run docker and to read files/folders - you could change or delete  this files/folders.
	@docker run --rm -v $(DATA_PATH):/data alpine sh -c 'rm -rf /data/*'

re: fclean all

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

prepare:
	@mkdir -p "$(DATA_PATH)"
	@mkdir -p "$(SECRETS_DIR)"
	@for file in $(SECRETS); do \
		if [ ! -f "$(SECRETS_DIR)/$$file" ]; then \
			openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c 1 > "$(SECRETS_DIR)/$$file" ;\
			openssl rand 256 | tr -dc 'a-zA-Z0-9!@#%^*_+'| head -c 31 >> "$(SECRETS_DIR)/$$file" ;\
			echo "Warning: Required file not found: $(SECRETS_DIR)/$$file and was created with random value." ;\
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



.PHONY: install run debug clean fclean help info prepare check