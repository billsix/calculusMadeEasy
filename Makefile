.DEFAULT_GOAL := help

PODMAN_CMD = podman
CONTAINER_NAME = calculusmadeeasy
FILES_TO_MOUNT = -v ./output/:/output/:Z

USE_X = -e DISPLAY=$(DISPLAY) \
	-v /tmp/.X11-unix:/tmp/.X11-unix


.PHONY: all
all: clean image pdf ## Build the PDF from scratch in Debian Bulleye

.PHONY: image
image: ## Build a podman image in which to build the book
	$(PODMAN_CMD) build -t $(CONTAINER_NAME) .


.PHONY: pdf
pdf: image ## Build the pdf from source
	$(PODMAN_CMD) run -it --rm  \
		$(FILES_TO_MOUNT) \
		$(CONTAINER_NAME)


.PHONY: clean
clean: ## Delete the output directory, cleaning out the HTML and the PDF
	rm -rf output/*

.PHONY: shell
shell: image ## Execute the shell
	$(PODMAN_CMD) run -it --rm  \
                --entrypoint /bin/bash \
                $(FILES_TO_MOUNT) \
		$(CONTAINER_NAME)


.PHONY: help
help:
	@grep --extended-regexp '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
