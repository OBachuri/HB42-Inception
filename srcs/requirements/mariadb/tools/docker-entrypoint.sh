#!/bin/bash

set -Eeuo pipefail

DATADIR="/var/lib/mysql"
DB_DIR="${DATADIR}/${MARIADB_WP_DATABASE}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld 



if [ ! -d "$DATADIR/mysql" ]; then
	# DB must be initialize ...
	echo "Initializing MariaDB data directory and creating database..."

	mkdir -p "${DATADIR}/mlog"
	chown -R mysql:mysql "${DATADIR}"
    
    ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_pass)
    ADMIN_PASSWORD=$(cat /run/secrets/mariadb_admin_pass)
    WP_PASSWORD=$(cat /run/secrets/mariadb_wp_user_pass)
	
	: "${MARIADB_WP_DATABASE:?Error: MARIADB_WP_DATABASE environment variable is required.}"
	: "${MARIADB_ADMIN_USER:?Error: MARIADB_ADMIN_USER environment variable is required.}"
	: "${MARIADB_WP_USER:?Error: MARIADB_WP_USER environment variable is required.}"

	: "${ROOT_PASSWORD:?Error: MYSQL_ROOT_PASSWORD environment variable is required.}"
	: "${ADMIN_PASSWORD:?Error: MYSQL_ADMIN_PASSWORD environment variable is required.}"
	: "${WP_PASSWORD:?Error: WP_PASSWORD environment variable is required.}"
	
	# don't work for me 
	# mysql_install_db --user=mysql --datadir=$DATADIR --init-file=/dev/stdin<<EOF my_sql_code EOF 	
  
    # Base installation of MARIADB (only creates default system tables/schemas)
    mysql_install_db --user=mysql --datadir="$DATADIR" --skip-test-db > /dev/null

	echo "Creating custom databases and users via bootstrap..."	
	# sleep 1

	mysqld --user=mysql --datadir="$DATADIR" --bootstrap <<EOF
-- USE mysql;
FLUSH PRIVILEGES; 
-- set password for root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';

-- create admin user
CREATE USER IF NOT EXISTS '${MARIADB_ADMIN_USER}'@'%'
IDENTIFIED BY '${ADMIN_PASSWORD}';

GRANT ALL PRIVILEGES ON *.* TO '${MARIADB_ADMIN_USER}'@'%' WITH GRANT OPTION;

-- create wp database and users

CREATE DATABASE IF NOT EXISTS \`${MARIADB_WP_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_WP_USER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_WP_DATABASE}\`.* TO '${MARIADB_WP_USER}'@'%';

FLUSH PRIVILEGES;
EOF

	echo "Initialization MariaDB complete."
	# sleep 1
fi

exec "$@"