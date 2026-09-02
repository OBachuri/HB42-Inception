FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        mariadb-server \

# COPY 
# WORKDIR
# ENV

# Define build arguments passed from docker-compose.yml
# ARG  

EXPOSE  3306

# Define the command to run the app
CMD ["mysqld", "--user=mysql"]