FROM        debian:stretch-slim
MAINTAINER  Francesco Ciocchetti <primeroznl@gmail.com>

ENV VERSION 0.8.0
ENV SHA256 2b1da4218fc5a1531ed17663ba5656c6bb5ce3db0ad6c2bdd6781d7f1b545816
ENV URL https://github.com/prometheus/haproxy_exporter/releases/download/v${VERSION}/haproxy_exporter-${VERSION}.linux-amd64.tar.gz

RUN set -ex \
	&& apt-get update \
	&& apt-get upgrade -y -q \
	&& apt-get install -qq --no-install-recommends ca-certificates wget \
  && apt-get clean all \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex \
        && mkdir /tmp/build \
        && cd /tmp/build \
        && wget -qO haproxy_exporter.tar.gz "$URL" \
        && echo -n "$SHA256 haproxy_exporter.tar.gz" | sha256sum -c \
        && tar -xzvf haproxy_exporter.tar.gz --strip-components=1 \
        && mkdir /opt/bin \
        && mv haproxy_exporter /opt/bin \
        && chmod a+x /opt/bin/haproxy_exporter \
        && rm -rf /tmp/build


ENTRYPOINT ["/bin/haproxy_exporter"]
EXPOSE     9101

