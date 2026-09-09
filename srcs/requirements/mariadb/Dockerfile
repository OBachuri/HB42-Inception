FROM debian:bookworm-slim

RUN apt-get -y update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && rm -rf /var/lib/mysql/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# RUN --mount=type=secret,id=mariadb_root_pass \
#     --mount=type=secret,id=mariadb_admin_pass \
#     --mount=type=secret,id=mariadb_wp_user_pass

EXPOSE  3306

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Define the command to run the app
# CMD ["sh", "--user=mysql"]
CMD ["mysqld", "--user=mysql"]