PODMAN_COMPOSE ?= podman-compose
COMPOSE_FILE_NAME ?= compose.yaml
COMPOSE_DEV_FILE_NAME ?= compose-dev.yaml
GO ?= go
ADDLICENSE ?= addlicense

compose: compose-down compose-up

compose-down:
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_FILE_NAME) down

compose-up:
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_FILE_NAME) up -d --build

compose: compose-down compose-up

compose-dev-down:
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_DEV_FILE_NAME) down

compose-dev-up:
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_DEV_FILE_NAME) up -d --build

compose-dev:
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_DEV_FILE_NAME) down
	$(PODMAN_COMPOSE) -f deployments/compose/$(COMPOSE_DEV_FILE_NAME) up -d --build
	make migrate-up
	echo wait until the horusec services finishes to build
	sleep 110
	podman restart horusec-vulnerability
	podman restart horusec-webhook
	podman restart horusec-core
	podman restart horusec-api
	podman restart horusec-messages
	podman restart horusec-analytic
	echo all services ready to use

install: compose migrate
	podman restart horusec-auth
	echo "Waiting grpc connection..." && sleep 5
	podman restart horusec-vulnerability
	podman restart horusec-webhook
	podman restart horusec-core
	podman restart horusec-api
	podman restart horusec-messages
	podman restart horusec-analytic

migrate: migrate-up

cleanup-migrate: migrate-drop migrate-up

migrate-drop:
	chmod +x ./deployments/scripts/migration-run.sh
	./deployments/scripts/migration-run.sh drop

migrate-up:
	chmod +x ./deployments/scripts/migration-run.sh
	./deployments/scripts/migration-run.sh up

run-web:
	podman run --privileged --name horusec-all-in-one -p 8000:8000 -p 8001:8001 -p 8003:8003 -p 8004:8004 \
	-p 8005:8005 -p 8006:8006 -p 8043:8080 -d horuszup/horusec-all-in-one:latest

stop-web:
	podman rm -f horusec-all-in-one

license:
	$(GO) install github.com/google/addlicense@latest
	@$(ADDLICENSE) -check -f ./copyright.txt $(shell find -regex '.*\.\(go\|js\|ts\|yml\|yaml\|sh\|podmanfile\)')

license-fix:
	$(GO) install github.com/google/addlicense@latest
	@$(ADDLICENSE) -f ./copyright.txt $(shell find -regex '.*\.\(go\|js\|ts\|yml\|yaml\|sh\|podmanfile\)')
