.DEFAULT_GOAL := default

IMAGE ?= yourapplication:latest

export DOCKER_CLI_EXPERIMENTAL=enabled

.PHONY: build # Build the container image
build:
	@docker buildx create --use --name=crossplat --node=crossplat && \
	docker buildx build \
		--tag $(IMAGE) \
		--load \
		.

.PHONY: publish # Push the image to the remote registry
publish:
	@docker buildx create --use --name=crossplat --node=crossplat && \
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--tag $(IMAGE) \
		--push \
		.
