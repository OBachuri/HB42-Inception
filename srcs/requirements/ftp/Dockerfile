FROM debian:bookworm-slim

RUN apt-get -y update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    	vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 20 21 21210-21220

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]