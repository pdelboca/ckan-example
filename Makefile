default: help

help:	## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install-ckan: | _check_virtualenv	## Install CKAN (it will clone a local copy into ckan folder and pip install it)
	./scripts/install-ckan.sh

install-extensions: | _check_virtualenv	## Install all third parties extensions from their Github Repositories.
	./scripts/install-ckan-extensions.sh

install-main-extension: | _check_virtualenv	## Install the main extension (the one hosted in this repository)
	./scripts/install-main-extension.sh

up:	## Run all the CKAN services from docker compose (database, Solr and Redis)
	docker compose up --no-attach ckan_solr --no-attach ckan_redis

down:	## Stop all the CKAN Services (database, Solr and Redis)
	docker compose down

clean:	## Stop all the CKAN Services and remove volumes and docker networks.
	docker compose down -v

build:  ## Build the main CKAN Dockerfile for deployment
	docker build .

_check_virtualenv:
	@if [ -z "$(VIRTUAL_ENV)" ] || [ ! -d ".venv" ]; then \
	  echo "Virtual environment not activated - create one at .venv folder and activate it."; \
	  exit 1; \
	fi
