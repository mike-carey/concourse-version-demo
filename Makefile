#!/usr/bin/env make

API ?= api
VENDOR ?= vendor

CONCOURSE_DOCKER ?= $(VENDOR)/concourse-docker

.PHONY: keys

env: .envrc
	direnv allow

.envrc:
	cp .envrc.example .envrc

api-change:
	printf '.' >> $(API)/Dotfile
	git add $(API)/Dotfile
	git ci -m ". $$(date)" $(API)/Dotfile
	git push

# Docker setup
keys:
keys/generate:
	./bin/generate-keys

start: keys/generate
	docker-compose -f $(CONCOURSE_DOCKER)/docker-compose.yml up -d
