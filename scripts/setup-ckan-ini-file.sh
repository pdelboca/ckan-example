# !/bin/bash -e

ckan config-tool /app/ckan.ini "SECRET_KEY = ${SECRET_KEY}"
ckan config-tool /app/ckan.ini "beaker.session.secret = ${BEAKER_SESSION_SECRET}"
ckan config-tool /app/ckan.ini "beaker.session.validate_key = ${BEAKER_SESSION_VALIDATE_KEY}"
ckan config-tool /app/ckan.ini "debug = ${CKAN_DEBUG}"
ckan config-tool /app/ckan.ini "ckan.site_url = ${CKAN_SITE_URL}"
ckan config-tool /app/ckan.ini "ckan.storage_path = /app/storage"
# Example: postgresql://<user>:<pass>@<name>.postgres.database.azure.com/ckan?sslmode=require
ckan config-tool /app/ckan.ini "sqlalchemy.url = ${SQLALCHEMY_URL}"
# Example: https://<name>.azurewebsites.net/solr/ckan
ckan config-tool /app/ckan.ini "solr_url = ${SOLR_URL}"
# Example: 'rediss://default:<pass>@<name>.redis.cache.windows.net:6380'
ckan config-tool /app/ckan.ini "ckan.redis.url = ${CKAN_REDIS_URL}"
# Example: postgresql://<user>:<pass>@<name>.postgres.database.azure.com/datastore_default?sslmode=require
ckan config-tool /app/ckan.ini "ckan.datastore.write_url = ${DATASTORE_WRITE_URL}"
ckan config-tool /app/ckan.ini "ckan.datastore.read_url = ${DATASTORE_READ_URL}"
ckan config-tool /app/ckan.ini "ckanext.datapusher_plus.ssl_verify = ${SSL_VERIFY}"
ckan config-tool /app/ckan.ini -s logger_ckan "level = ${LOGGER_CKAN_LEVEL}"
ckan config-tool /app/ckan.ini -s logger_ckanext "level = ${LOGGER_CKANEXT_LEVEL}"

cat /app/ckan.ini

echo "Configuration file setup complete"
