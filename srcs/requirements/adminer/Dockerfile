FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG A_PHP_VERSION=8.5
ARG ADMINER_VERSION=6.1.0

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        lsb-release \
      #  mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Add the PHP repository to the system
RUN curl -fsSL \
        --retry 5 \
        --retry-delay 2 \
        https://packages.sury.org/php/apt.gpg -o /usr/share/keyrings/sury-php.gpg  \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Install PHP
RUN apt-get -y update && apt -y upgrade \
    && apt-get install -y --no-install-recommends \
        php${A_PHP_VERSION}-cli \
        php${A_PHP_VERSION}-mysql \
        php${A_PHP_VERSION}-pgsql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download Adminer (single PHP file)
RUN mkdir -p /var/www/adminer && \
    curl -L -o /var/www/adminer/index.php \
    "https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php"

# Make sure PHP-FPM user owns WordPress files
RUN chown -R www-data:www-data /var/www/adminer

EXPOSE 8080

WORKDIR /var/www/adminer

ENV A_PHP_VERSION=${A_PHP_VERSION}

# Run PHP's built-in web server — lightweight, no nginx needed
CMD php${A_PHP_VERSION} -S 0.0.0.0:8080 -t /var/www/adminer
# CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
