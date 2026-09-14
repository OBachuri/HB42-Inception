#!/bin/bash

# start chromium with static DNS record for my site

# Enable automatically exporting all defined variables
set -a ; \
source srcs/.env ; \
chromium-browser \
  --user-data-dir=/tmp/chrome-test \
  --host-resolver-rules="MAP $DOMAIN_NAME 127.0.0.1" \
  https://$DOMAIN_NAME:4443

set +a
