# -*- Makefile -*-
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

container := general-template
image := $(container)

.PHONY: help
help: ## Show usage information for this Makefile.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the container locally for testing.
	env DOCKER_BUILDKIT=1 docker build -t $(image) .

.PHONY: run
run: ## Run the container in development mode.
	docker run --restart unless-stopped --name $(CONTAINER_NAME) -d $(image)

.PHONY: test
test: ## Run unit tests.
	@echo "Implement me"

.PHONY: shell
shell: ## Open a shell into the running container.
	docker exec -it $(container) bash
