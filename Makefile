# -*- Makefile -*-

IMAGE_NAME := general-template
CONTAINER_NAME := general-template

default:
	@echo "Read the makefile"

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --restart unless-stopped --name $(CONTAINER_NAME) -d $(IMAGE_NAME)

test:
	@echo "Implement me"

shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
