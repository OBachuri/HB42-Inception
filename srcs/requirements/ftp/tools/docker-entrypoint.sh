#!/bin/bash

set -Eeuo pipefail

: "${FTP_USER:?Error: Variable FTP_USER is required}"
: "${DOMAIN_NAME:?Error: Variable DOMAIN_NAME is required}"


# Create FTP config
cat << EOF > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
background=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=21000
pasv_max_port=21010
pasv_address=${DOMAIN_NAME}
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
secure_chroot_dir=/var/run/vsftpd/empty
EOF


# Create FTP user at RUNTIME (not build time)
# This keeps passwords out of the Docker image layers.
if ! id "$FTP_USER" &>/dev/null; then

    FTP_USER_PASS=$(cat /run/secrets/ftp_user_pass)

	: "${FTP_USER_PASS:?Error: Variable FTP_USER_PASS is required}"

    echo "Creating user '${FTP_USER}'..."
    useradd -m -s /bin/bash -g www-data -d /var/www/html "$FTP_USER"
    echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
    # Ensure group-writable so both www-data (PHP-FPM) and FTP user can coexist
    # chmod -R g+w /var/www/html
    echo "[FTP] User created (member of www-data group)."
	# Add user to the allow list (idempotent)
	grep -qxF "${FTP_USER}" /etc/vsftpd.userlist 2>/dev/null || echo "${FTP_USER}" >> /etc/vsftpd.userlist

# else
#     echo "User '${FTP_USER}' already exists."
fi


echo "Starting FTP..."

exec "$@"