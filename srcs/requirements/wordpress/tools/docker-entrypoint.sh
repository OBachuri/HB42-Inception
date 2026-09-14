#!/bin/bash

set -Eeuo pipefail

WP_DIR="/var/www/html"
WP_CONFIG="${WP_DIR}/wp-config.php"

# Navigate to web root
cd ${WP_DIR}

if [ ! -f "${WP_CONFIG}" ]; then 

	echo "Creating ${WP_CONFIG}..."

	: "${WP_DB_NAME:?Error: Variable WP_DB_NAME is required}" 
	: "${WP_DB_USER:?Error: Variable WP_DB_USER is required}" 
	: "${WP_DB_HOST:?Error: Variable WP_DB_HOST is required}"
	: "${DOMAIN_NAME:?Error: Variable DOMAIN_NAME is required}"

    WP_DB_PASSWORD=$(cat /run/secrets/mariadb_wp_user_pass)
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_pass)
    WP_USER=$(cat /run/secrets/wp_user_pass)

	cat > "${WP_CONFIG}" <<EOF
<?php
define( 'DB_NAME', '${WP_DB_NAME}' );
define( 'DB_USER', '${WP_DB_USER}' );
define( 'DB_PASSWORD', '${WP_DB_PASSWORD}' );
define( 'DB_HOST', '${WP_DB_HOST}' );

/*
define( 'WP_SITEURL', 'https://${DOMAIN_NAME}:4443'); 
define( 'WP_HOME', 'https://${DOMAIN_NAME}:4443'); 
*/

define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );
/* define( 'WP_DEBUG', false ); */ 
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) { 
	define( 'ABSPATH', __DIR__ . '/' ); 
} 
require_once ABSPATH . 'wp-settings.php';
EOF

	chown www-data:www-data "${WP_CONFIG}"
	chmod 640 "${WP_CONFIG}"

	echo "File wp-config.php created."

fi

sleep 3

if ! wp core is-installed --path="${WP_DIR}" --allow-root; then

	: "${WP_VERSION:?Error: Variable WP_VERSION is required}"
	: "${DOMAIN_NAME:?Error: Variable DOMAIN_NAME is required}"
	: "${WP_TITLE:?Error: Variable WP_TITLE is required}"
	: "${WP_ADMIN_USER:?Error: Variable WP_ADMIN_USER is required}"
	: "${WP_ADMIN_EMAIL:?Error: Variable WP_ADMIN_EMAIL is required}"
	: "${WP_USER:?Error: Variable WP_USER is required}"
	: "${WP_USER_EMAIL:?Error: Variable WP_USER_EMAIL is required}"

    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_pass)
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_pass)

	# Check if the core code is present and valid
	if wp core verify-checksums --allow-root > /dev/null 2>&1; then
		echo "WordPress core is downloaded and 100% authentic."
	else
		echo "Downloading WordPress ${WP_VERSION} ..."

		curl -fsSL \
			"https://wordpress.org/wordpress-${WP_VERSION}.zip" \
			-o /tmp/wordpress.zip \
		&& unzip /tmp/wordpress.zip -d /tmp \
		&& cp -a /tmp/wordpress/. ${WP_DIR}/ \
		&& rm -rf /tmp/wordpress /tmp/wordpress.zip

		chown -R www-data:www-data "$WP_DIR"
	fi

	echo "Installing WordPress..."

	wp core install \
        --path="${WP_DIR}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Creating regular WP user..."

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
		--allow-root

	# wp option update home "https://${DOMAIN_NAME}:4443" --allow-root
	# wp option update siteurl "https://${DOMAIN_NAME}:4443" --allow-root
	
	echo "<?php phpinfo();" > $WP_DIR/testphp.php
	
fi
	
chown -R www-data:www-data "$WP_DIR"

echo "Starting PHP-FPM..."

exec "$@"