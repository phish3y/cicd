.PHONY: build
build:
	docker build -t cicd .

.PHONY: up
up: build
	docker run -d -p 7878:7878 cicd

.PHONY: down
down:
	@for container in $(shell docker ps -q); do \
		docker kill $$container; \
	done
	@for container in $(shell docker ps -a -q); do \
		docker rm $$container; \
	done
