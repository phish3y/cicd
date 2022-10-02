.PHONY: build
build:
	docker build -t cicd .

.PHONY: up
up: build
	docker run -d -p 7878:7878 cicd

.PHONY: down
down:
	docker kill $(shell docker ps -q)
	docker rm $(shell docker ps -a -q)