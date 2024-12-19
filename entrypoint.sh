#!/bin/bash -e

echo "Executing entrypoint.sh"

echo "Setting up config file with env variables..."
./scripts/setup-ckan-ini-file.sh

# Wait for the database to be ready
until psql -d $SQLALCHEMY_URL -c '\q'; do
  echo "Postgres is unavailable - sleeping. Response: $?"
  sleep 3
done

echo "CKAN DB init..."
ckan db init

echo "Datapusher+ DB upgrade..."
ckan db upgrade -p datapusher_plus

echo "Rebuilding search index..."
ckan search-index rebuild

echo "Updating tracking since 60 days ago..."
LAST_MONTH=$(date -d '60 days ago' +'%Y-%m-%d')
ckan tracking update $LAST_MONTH

# Datapusher+ requires a valid API token to operate
# We could also create one manually after the first setup and add it to the ENV files.
# We are using the user named "default", which is created by CKAN core.
echo "Creating a valid API token for Datapusher+..."
DATAPUSHER_TOKEN=$(ckan user token add default datapusher_multi expires_in=365 unit=86400 | tail -n 1 | tr -d '\t')
ckan config-tool ckan.ini "ckan.datapusher.api_token=${DATAPUSHER_TOKEN}"
ckan config-tool ckan.ini "ckanext.datapusher_plus.api_token=${DATAPUSHER_TOKEN}"

# Rebuild webassets in case they were patched
echo "Rebuilding CKAN webassets..."
ckan asset build

# Start supervidor
echo "Starting supervisor..."
service supervisor start

echo "Finished entrypoint.sh"
sleep 3
echo "************************************************"
echo "************************************************"
echo "*********** CKAN is ready to use ***************"
echo "************ at $CKAN_SITE_URL *****************"
echo "************************************************"
echo "************************************************"

# Any other command to continue running and allow to stop CKAN
tail -f /var/log/supervisor/*.log
