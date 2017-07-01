FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV SRC_DIR /usr/local/src
WORKDIR $SRC_DIR

RUN set -x \
  && buildDeps=' \
      ca-certificates \
      cmake \
      g++ \
      git \
      libboost1.58-all-dev \
      libssl-dev \
      make \
      pkg-config \
      golang \
  ' \
  && apt-get -qq update \
  && apt-get -qq --no-install-recommends install $buildDeps

ENV MONERO_TAG v0.10.3.1

RUN set -ex && git clone https://github.com/monero-project/monero.git monero-src
RUN set -ex && cd monero-src && git checkout tags/$MONERO_TAG \
                && cmake -DBUILD_SHARED_LIBS=1 .\
                && make -j$(nproc)

RUN set -ex && mkdir -p $SRC_DIR/monero $SRC_DIR/monero/bin $SRC_DIR/monero/lib \
						&& cp -a $SRC_DIR/monero-src/bin/* $SRC_DIR/monero/bin \
						&& find $SRC_DIR/monero-src/ -type f -name "*.so" -exec cp {} $SRC_DIR/monero/lib/ \;

ENV GOPATH /usr/local/src/go

RUN set -ex && git clone https://github.com/sammy007/monero-stratum.git
RUN set -ex && cd monero-stratum \
						&& go get github.com/goji/httpauth \
						&& go get github.com/yvasiyarov/gorelic \
						&& go get github.com/gorilla/mux \
						&& MONERO_DIR=/usr/local/src/monero-src cmake . \
						&& make \
						&& go build -o pool main.go
#go build --ldflags '-extldflags "-static"' -o pool main.go 

RUN set -ex && mkdir -p $SRC_DIR/pool \
						&& cp -a $SRC_DIR/monero-stratum/pool $SRC_DIR/pool/

RUN set -ex && rm -rf $SRC_DIR/monero-src \
						&& rm -rf $SRC_DIR/monero-stratum \
						&& rm -rf $SRC_DIR/go

RUN set -ex && strip $SRC_DIR/monero/bin/* $SRC_DIR/monero/lib/* $SRC_DIR/pool/*

RUN echo "/usr/local/src/monero/lib" > /etc/ld.so.conf.d/monero.conf && ldconfig

ENV LOG_LEVEL 0
ENV P2P_BIND_IP 0.0.0.0
ENV P2P_BIND_PORT 18080
ENV RPC_BIND_IP 127.0.0.1
ENV RPC_BIND_PORT 18081
ENV WALLET_RPC_BIND_IP 127.0.0.1
ENV WALLET_RPC_BIND_PORT 18082
ENV WALLET_FILE pool
ENV WALLET_password password

EXPOSE 18080
#EXPOSE 18081
#EXPOSE 18082

VOLUME /redis
VOLUME /pool
VOLUME /monerod


RUN mkdir /etc/service/redis
COPY redis.sh /etc/service/redis/run
RUN chmod +x /etc/service/redis/run

RUN mkdir /etc/service/monerod
COPY monerod.sh /etc/service/monerod/run
RUN chmod +x /etc/service/monerod/run

RUN mkdir /etc/service/monero-wallet-rpc
COPY monero-wallet-rpc.sh /etc/service/monero-wallet-rpc/run
RUN chmod +x /etc/service/monero-wallet-rpc/run

RUN set -ex && apt-get purge -y --auto-remove git make cmake gcc g++ golang
RUN set -ex && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* 
