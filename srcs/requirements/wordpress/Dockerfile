FROM debian:bookworm-slim

# Set it only for the build process
ARG DEBIAN_FRONTEND=noninteractive
ARG WP_PHP_VERSION=8.5
ARG WP_VERSION=7.1

ENV WP_PHP_VERSION=8.5

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        lsb-release \
        unzip \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Add the PHP repository to the system
RUN curl -fsSL \
        --retry 5 \
        --retry-delay 2 \
        https://packages.sury.org/php/apt.gpg -o /usr/share/keyrings/sury-php.gpg  \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Install PHP
RUN PACKAGES=" \
        php${WP_PHP_VERSION}-fpm \
        php${WP_PHP_VERSION}-mysql \
        php${WP_PHP_VERSION}-curl \
        php${WP_PHP_VERSION}-gd \
        php${WP_PHP_VERSION}-xml \
        php${WP_PHP_VERSION}-mbstring \
        php${WP_PHP_VERSION}-zip \
        php${WP_PHP_VERSION}-intl \
        php${WP_PHP_VERSION}-redis \
        php${WP_PHP_VERSION}-pdo \
        php${WP_PHP_VERSION}-imagick \
    " && \
    if [ "$(echo "${WP_PHP_VERSION} < 8.5" | bc 2>/dev/null || awk "BEGIN {print (${WP_PHP_VERSION} < 8.5)}")" -eq 1 ]; then \
        PACKAGES="$PACKAGES php${WP_PHP_VERSION}-opcache"; \
    fi \
    && apt-get -y update && apt -y upgrade \
    && apt-get install -y --no-install-recommends $PACKAGES \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Modify PHP fpm the pool configuration to listen on network port 9000
RUN sed -i 's|^listen =.*|listen = 9000|' /etc/php/${WP_PHP_VERSION}/fpm/pool.d/www.conf

# Verify php installations
RUN php -m  

# WordPress workdir
WORKDIR /var/www/html

RUN curl -fsSL \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

RUN wp --info

# Take WP files from  https://wordpress.org/wordpress-7.1.zip
# RUN curl -fsSL \
#         "https://wordpress.org/wordpress-${WP_VERSION}.zip" \
#         -o /tmp/wordpress.zip \
#     && unzip /tmp/wordpress.zip -d /tmp \
#     && cp -a /tmp/wordpress/. /var/www/html/ \
#     && rm -rf /tmp/wordpress /tmp/wordpress.zip

# Make sure PHP-FPM user owns WordPress files
RUN chown -R www-data:www-data /var/www/html

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start PHP-FPM
CMD ["sh", "-c", "php-fpm${WP_PHP_VERSION} -F"]
# CMD ["php${WP_PHP_VERSION}-fpm", "-F"]



