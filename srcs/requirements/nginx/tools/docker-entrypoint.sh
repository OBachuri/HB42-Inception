#!/bin/bash

set -Eeuo pipefail

CERT_DIR="/etc/nginx/ssl"

mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/nginx.key" ] || \
   [ ! -f "$CERT_DIR/nginx.crt" ] || \
   ! openssl x509 \
		-checkend 2592000 \
		-noout \
		-in "$CERT_DIR/nginx.crt" ; then 
	
	echo "Certificate is missing or valid for less than 30 day."

	: "${DOMAIN_NAME:?Error: Variable DOMAIN_NAME is required}"

    echo "Generating new certificate for ${DOMAIN_NAME}..."

	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout $CERT_DIR/nginx.key \
		-out $CERT_DIR/nginx.crt \
		-subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=42/OU=Inception/CN=CN=${DOMAIN_NAME}" \
		-addext "subjectAltName=DNS:${DOMAIN_NAME},DNS:me.${DOMAIN_NAME}"; \

    chmod 600 "$CERT_DIR/nginx.key"

    echo "Certificate generated."
fi

exec "$@"