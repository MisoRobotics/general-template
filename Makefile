# -*- Makefile -*-

# SECTION 1: INCLUDES

# SECTION 2: SETTINGS
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := default

# Disable default implicit rule definitions.
#
# Suffixes are considered outdated since pattern rules are more general and
# clearer; see:
# https://www.gnu.org/software/make/manual/html_node/Suffix-Rules.html
.SUFFIXES:

# Remove target if recipe fails.
#.DELETE_ON_ERROR:

# SECTION 3: ENVIRONMENT VARIABLES

# Mention variables that might not be set to avoid warnings from
# --warn-undefined-variables.
export COLOR ?=
export MAKESILENT ?=
export VERBOSE ?=


IMAGE_NAME := general-template
CONTAINER_NAME := general-template

# SECTION 4: LOCAL VARIABLES

# Store the current directory from which Make is being called.
this_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# The home directory of the user in the Docker container.
docker_home := /root

## RUN OPTIONS

# The following variables can be added to a docker run command to enable
# capabilities as desired.

# Map local user/group identities so permissions don't get clobbered on
# mounted volumes.
run_as_user := --user=$(shell id -u):$(shell id -g)

# Enable X11 forwarding by mounting a socket and credentials.
run_with_x11 := $\
	-e DISPLAY=$(DISPLAY) \
	-e QT_X11_NO_MITSHM=1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v $(HOME)/.Xauthority:$(DOCKER_HOME)/.Xauthority:ro \
	--device=/dev/dri

# Use the nvidia runtime to forward CUDA and other capabilities.
run_with_nvidia := $\
	--runtime=nvidia \
	-e NVIDIA_VISIBLE_DEVICES=all \
	-e NVIDIA_DRIVER_CAPABILITIES=all

# Enable the use of ptrace which is used by, e.g., GDB.
run_with_ptrace := --cap-add=SYS_PTRACE

# SECTION 5: Rules

default:
	@echo "Read the makefile"

build:
	docker build -t $(IMAGE_NAME) $(this_dir)

run:
	docker run --restart unless-stopped --name $(CONTAINER_NAME) -d $(IMAGE_NAME)

test:
	@echo "Implement me"

shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
