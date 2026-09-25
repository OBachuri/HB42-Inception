FROM debian:bookworm-slim

ENV NGINX_PORT=443

RUN apt-get -y update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        nginx \
        openssl \
        ca-certificates \
        curl  \
        unzip \
        gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/nginx/sites-available/*

# Copy the config file 
# COPY conf/nginx.conf /etc/nginx/nginx.conf

# Download PacMan
RUN mkdir -p /var/www/game \
    && curl -L --output /var/www/game/pacman.zip https://github.com/OBachuri/HB42-Pac-Man/releases/download/name/PacMan-42-web-apk.zip \
    && unzip /var/www/game/pacman.zip -d /var/www/game \
    && rm -rf /var/www/game/pacman.zip

# Make sure www-data user owns files
RUN chown -R www-data:www-data /var/www/game

COPY conf/nginx.template /etc/nginx/sites-available/nginx.template

# Expose the port the app runs on
EXPOSE  ${NGINX_PORT}

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Define the command to run the app
CMD ["nginx", "-g", "daemon off;"]