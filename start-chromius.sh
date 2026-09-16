#!/bin/bash

# start chromium with static DNS record for my site

# Enable automatically exporting all defined variables
set -a ; \
source srcs/.env ; \
chromium-browser \
  --user-data-dir=/tmp/chrome-test \
  --host-resolver-rules="MAP $DOMAIN_NAME 127.0.0.1" \
  https://$DOMAIN_NAME:$NGINX_PORT https://$DOMAIN_NAME:$NGINX_PORT/wp-admin "https://$DOMAIN_NAME:$NGINX_PORT/adminer/?server=$WP_DB_HOST&username=$MARIADB_ADMIN_USER&db=$MARIADB_WP_DATABASE"
  
  # "http://$DOMAIN_NAME:8080/?server=$WP_DB_HOST&username=$MARIADB_ADMIN_USER&db=$MARIADB_WP_DATABASE"

set +a


# test ftp 
# curl -v --user 'obachuri:Pass_for_ftp' ftp://localhost:1121/
