#!/usr/bin/env make

SSH_KEY ?= $(HOME)/.ssh/id_rsa
FLY_TARGET ?= concourse
PIPELINE_NAME ?= version-demo

.PHONY: pipeline *

pipeline: .vars.yml
	@fly -t $(FLY_TARGET) sp \
			-p $(PIPELINE_NAME) \
			-c pipeline.yml \
			-l .vars.yml
	@fly -t $(FLY_TARGET) up \
			-p $(PIPELINE_NAME)
# ifeq ($(shell uname -s),Darwin)
# 	@echo "Opening pipeline in your browser"
# 	@hash yq && open $$(fly targets | awk '{ if ($$1 == "'$(FLY_TARGET)'") { print $$2; }; }')/teams/$$(fly targets | awk '{ if ($$1 == "'$(FLY_TARGET)'") { print $$3; }; }')/pipelines/$(PIPELINE_NAME)
# endif

pipeline.yml:
	jinja2 pipeline.yml.j2 config.yml -o pipeline.yml

.vars.yml:
	@cp vars.yml .vars.yml
	@echo "git_private_key: |-" >> .vars.yml
	@echo '' >> .vars.yml
	@cat $(SSH_KEY) | sed 's/^\(.*\)/  \1/g' >> .vars.yml

destroy:
	@fly -t $(FLY_TARGET) dp \
	 		-p $(PIPELINE_NAME)
