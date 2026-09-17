FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        prometheus \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/prometheus  /var/lib/prometheus

COPY conf/prometheus.yml /etc/prometheus/prometheus.yml

RUN chown -R prometheus:prometheus /var/lib/prometheus

EXPOSE 9090

USER prometheus

CMD ["prometheus", \
     "--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/var/lib/prometheus", \
     "--storage.tsdb.retention.time=15d"]
