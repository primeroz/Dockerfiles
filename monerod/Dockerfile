FROM debian:stretch-slim

RUN groupadd -r monero && useradd -r -m -g monero monero

RUN set -ex \
	&& apt-get update \
	&& apt-get upgrade -y -q \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget bzip2 \
	&& rm -rf /var/lib/apt/lists/*

ENV MONEROD_VERSION v0.11.0.0
ENV MONEROD_URL https://downloads.getmonero.org/cli/monero-linux-x64-$MONEROD_VERSION.tar.bz2
ENV MONEROD_SHA256 fa7742c822f3c966aa842bf20a9920803d690d9db02033d9b397cefc7cc07ff4
ENV MONEROD_ASC_URL https://getmonero.org/downloads/hashes.txt
ENV MONEROD_PGP_KEY 0x7455c5e3c0cdceb9

# install bitcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO monero.tar.bz2 "$MONEROD_URL" \
	&& echo "$MONEROD_SHA256 monero.tar.bz2" | sha256sum -c - \
	&& gpg --keyserver sks-keyservers.net --recv-keys "$MONEROD_PGP_KEY" \
	&& wget -qO monerod.asc "$MONEROD_ASC_URL" \
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
