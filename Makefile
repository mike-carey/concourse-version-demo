#!/usr/bin/env make

.PHONY: *

env: .envrc
	direnv allow

.envrc:
	cp .envrc.example .envrc
