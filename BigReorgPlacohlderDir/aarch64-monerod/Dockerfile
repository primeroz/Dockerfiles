FROM arm64v8/alpine

RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache curl ca-certificates openssl gnupg bash shadow 

RUN groupadd -r monero && useradd -r -m -g monero monero

ENV GOSU_VERSION 1.10
ENV MONEROD_VERSION v0.12.3.0
ENV MONEROD_URL https://downloads.getmonero.org/cli/monero-linux-armv8-$MONEROD_VERSION.tar.bz2
ENV MONEROD_SHA256 a6e994dc9fcec7259b656752a6fc0f9686bad47da9deec0f50398718cd9b9be8
ENV MONEROD_ASC_URL https://getmonero.org/downloads/hashes.txt
ENV MONEROD_PGP_KEY 0x7455c5e3c0cdceb9

# grab gosu for easy step-down from root
RUN gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \                             
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64" \
    && curl -o /usr/local/bin/gosu.asc -L "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# install bitcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& curl -o monero.tar.bz2 "$MONEROD_URL" \
	&& echo "$MONEROD_SHA256  monero.tar.bz2" | sha256sum -c - \
	&& gpg --keyserver sks-keyservers.net --recv-keys "$MONEROD_PGP_KEY" \
	&& curl -o monerod.asc "$MONEROD_ASC_URL" \
	&& gpg --verify monerod.asc \
	&& tar -xjvf monero.tar.bz2 --strip-components=1 \
	&& mv monero-$MONEROD_VERSION/* /usr/local/bin \
	&& rm -rf /tmp/*

# create data directory
ENV MONERO_DATA /data
RUN mkdir "$MONERO_DATA" \
	&& chown -R monero:monero "$MONERO_DATA" \
	&& chown -h monero:monero "$MONERO_DATA"

ENV RPC_USER=user \
    RPC_PASSWORD=password \
    RPC_BIND_ADDRESS=127.0.0.1

VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 18080 18081
CMD ["/usr/local/bin/monerod", "--config-file","$MONERO_DATA/monero.conf"]
