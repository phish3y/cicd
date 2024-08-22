AWS_ACCOUNT_ID = 395440373408
ECR_REPO = cicd

# Install: https://golangci-lint.run/welcome/install/#local-installation
# Then add $(go env GOPATH)/bin/ to your PATH
# The Github Action (.github/workflows/golangci-lint.yaml) uses v1.59.1
GOLANGCI-LINT = golangci-lint

.PHONY: go-lint
go-lint:
	@$(GOLANGCI-LINT) run --fix

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

.PHONY: push
push:
	@docker tag cicd_server:latest $(AWS_ACCOUNT_ID).dkr.ecr.us-west-2.amazonaws.com/$(ECR_REPO)
	@docker push $(AWS_ACCOUNT_ID).dkr.ecr.us-west-2.amazonaws.com/$(ECR_REPO)
