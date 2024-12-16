default: help

help:	## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install-ckan: | _check_virtualenv	## Install CKAN and third-party extensions. (For CKAN it will clone a local copy into ckan folder)
	./install-ckan.sh
	./install-ckan-extensions.sh

up:	## Run all the CKAN services from docker compose (database, Solr and Redis)
	docker compose up --no-attach ckan_solr --no-attach ckan_redis -d

down:	## Stop all the CKAN Services (database, Solr and Redis)
	docker compose down

clean:	## Stop all the CKAN Services and remove volumes and docker networks.
	docker compose down -v

_check_virtualenv:
	@if [ -z "$(VIRTUAL_ENV)" ] || [ ! -d ".venv" ]; then \
	  echo "Virtual environment not activated - create one at .venv folder and activate it."; \
	  exit 1; \
	fi
