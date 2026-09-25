#!/bin/bash

set -e

MARIADB_EXPLORER_PASSWORD=$(cat /run/secrets/mariadb_exporter_pass)

mysql \
    --host=127.0.0.1 \
    --user=prometheus \
    --password="$MARIADB_EXPLORER_PASSWORD" \
    --execute="SELECT 1;" \
    >/dev/null
