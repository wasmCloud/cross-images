.DEFAULT_GOAL:=help

CROSS_VERSION := 0.2.1
IMAGE         := wasmcloud/cross

##@ Building

.PHONY: all Dockerfile.*

build: $(wildcard Dockerfile.*) ## Build all images
Dockerfile.*: ## Build specific image
	@docker build . -f $@ --build-arg VERSION=$(CROSS_VERSION) \
		-t $(IMAGE):$(@:Dockerfile.%=%)

release: build ## Build/push all images
	@docker push $(IMAGE):$(@:Dockerfile.%=%)

##@ Helpers

.PHONY: help

list: ## Display supported images
	@ls Dockerfile.* | sed -nE 's/Dockerfile\.(.*)/\1/p' | sort

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_\-.*]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
