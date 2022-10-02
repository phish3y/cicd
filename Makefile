.PHONY: build
build:
	@docker-compose build

.PHONY: up
up: build
	@docker-compose up

.PHONY: detach
detach: build
	@docker-compose up -d

.PHONY: down
down:
	@docker-compose down --remove-orphans
