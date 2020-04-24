#!/usr/bin/env make

# Locations
CI ?= ci
API ?= api
VENDOR ?= vendor

CONCOURSE_DOCKER ?= $(VENDOR)/concourse-docker

# Concourse Info
FLY_TARGET ?= concourse
FLY_USERNAME ?= test
FLY_PASSWORD ?= test
FLY_ENDPOINT ?= http://localhost:8080
FLY_TEAM ?= main

# Configurations
PIPELINE_NAME ?= version-demo

.PHONY: keys login start stop destroy pipeline env

.default_target: env

.envrc:
	cp .envrc.example .envrc

env: .envrc
	direnv allow

api-change:
	printf '.' >> $(API)/Dotfile
	git add $(API)/Dotfile
	git ci -m ". $$(date)" $(API)/Dotfile
	git push

login:
	fly -t $(FLY_TARGET) \
		login \
			-c $(FLY_ENDPOINT) \
			-u $(FLY_USERNAME) \
			-p $(FLY_PASSWORD) \
			-n $(FLY_TEAM)

pipeline:
	make -C $(CI) pipeline

destroy-pipeline:
	make -C $(CI) destroy

# Docker setup
keys:
keys/generate:
	./bin/generate-keys

start: keys/generate
	docker-compose -f $(CONCOURSE_DOCKER)/docker-compose.yml up -d

stop:
	docker-compose -f $(CONCOURSE_DOCKER)/docker-compose.yml stop

destroy:
	docker-compose -f $(CONCOURSE_DOCKER)/docker-compose.yml destroy
