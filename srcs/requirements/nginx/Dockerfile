FROM debian:bookworm-slim

RUN apt-get -y update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        nginx \
        openssl \
        curl  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the config file
# COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose the port the app runs on
EXPOSE  80 443

# Define the command to run the app
CMD ["nginx", "-g", "daemon off;"]