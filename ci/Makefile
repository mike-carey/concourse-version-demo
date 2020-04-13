#!/usr/bin/env make

SSH_KEY ?= $(HOME)/.ssh/id_rsa
FLY_TARGET ?= concourse
PIPELINE_NAME ?= version-demo

.PHONY: pipeline *

pipeline: .vars.yml
	fly -t $(FLY_TARGET) sp \
			-p $(PIPELINE_NAME) \
			-c pipeline.yml \
			-l .vars.yml

.vars.yml:
	cp vars.yml .vars.yml
	echo "git_private_key: |-" >> .vars.yml
	echo '' >> .vars.yml
	cat $(SSH_KEY) | sed 's/^\(.*\)/  \1/g' >> .vars.yml
