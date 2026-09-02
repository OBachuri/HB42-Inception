FROM debian:bookworm-slim

# Set it only for the build process
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_VERSION=8.5
ENV PHP_VERSION=${PHP_VERSION}

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg lsb-release unzip mariadb-client

# Add the PHP repository to the system
RUN curl -fsSL \
        --retry 5 \
        --retry-delay 2 \
        https://packages.sury.org/php/apt.gpg -o /usr/share/keyrings/sury-php.gpg  \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
    && apt -y update

RUN RUN apt-get -y update && apt -y upgrade && \
    apt-get install -y --no-install-recommends \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-imagick \
        php${PHP_VERSION}-opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# https://wordpress.org/wordpress-7.1.zip

# 3. Modify the pool configuration to listen on network port 9000
RUN sed -i 's|^listen =.*|listen = 9000|' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

WORKDIR /var/www/html

# Verify php installations
RUN php -m

EXPOSE 9000

# Start PHP-FPM
CMD ["php${PHP_VERSION}-fpm", "-F"]



