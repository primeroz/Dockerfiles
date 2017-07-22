FROM hypriot/rpi-alpine-scratch
#FROM sander85/rpi-alpine
MAINTAINER Francesco Ciocchetti <fciocchetti@gmail.com>

ENV SYNCTHING_VERSION 0.14.32
ENV GOSU_VERSION 1.10

RUN apk update \
  && apk upgrade \
  && apk add curl ca-certificates openssl gnupg bash

# grab gosu for easy step-down from root
RUN gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf" \
  && curl -o /usr/local/bin/gosu.asc -L "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf.asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# get syncthing
	#&& export version=${SYNCTHING_VERSION} \ 
WORKDIR /srv
RUN adduser -H -G users -u 1027 -D syncthing 
RUN set -ex && gpg --keyserver pgp.mit.edu --recv-keys D26E6ED000654A3E \
  && curl -L -o syncthing.tar.gz https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/syncthing-linux-arm-v$SYNCTHING_VERSION.tar.gz \
  && curl -L -o syncthing.tar.gz https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/sha256sum.txt.asc \
  && grep $(sha256sum syncthing.tar.gz) sha256sum.txt.asc \
  && gpg --verify sha256sum.txt.asc \
  && tar -xzvf syncthing.tar.gz \
  && rm -f syncthing.tar.gz \
  && mv syncthing-linux-arm-v* syncthing \
  && rm -rf syncthing/etc \
  && rm -rf syncthing/*.pdf \
  && mkdir -p /srv/config \
  && mkdir -p /srv/data \

VOLUME ["/srv/data", "/srv/config"]

ADD ./start.sh /srv/start.sh
RUN chmod 770 /srv/start.sh

ENV UID=1027

ENTRYPOINT ["/srv/start.sh"]

