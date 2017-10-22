# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

WORKDIR /tmp

# ...put your own build instructions here...
RUN set -ex && apt-get update -y
RUN set -ex && apt-get install -y --no-install-recommends \
  bzip2 \
  curl \
  wget \
  ca-certificates && \
  apt-get autoremove -y && \
  apt-get clean

ENV MONEROD_VERSION v0.11.0.0
ENV MONEROD_SHA256 fa7742c822f3c966aa842bf20a9920803d690d9db02033d9b397cefc7cc07ff4

RUN mkdir -p /bitmonerod

RUN set -ex && curl -L -o monero.tar.bz2  https://downloads.getmonero.org/cli/monero-linux-x64-$MONEROD_VERSION.tar.bz2 && \
	tar -xvjf monero.tar.bz2 && \
        echo "$MONEROD_SHA256 monero.tar.bz2" | sha256sum -c - && \
	mv monero-$MONEROD_VERSION/* /bitmonerod && \
    	rm monero.tar.bz2

RUN mkdir -p /monero
VOLUME /monero

ENV RPC_USER=user \
    RPC_PASSWORD=password

RUN mkdir /etc/service/monerod
COPY monerod.sh /etc/service/monerod/run
RUN chmod +x /etc/service/monerod/run

EXPOSE 18080 18081

# Clean up APT when done.
#RUN set -ex && apt-get purge -y --auto-remove build-essential libtool autotools-dev autoconf libssl-dev libboost-all-dev git  libminiupnpc-dev libdb4.8-dev libdb4.8++-dev \
        #&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN set -ex && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp*

