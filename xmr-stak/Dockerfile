FROM ubuntu:16.04

RUN groupadd -r monero && useradd -r -m -g monero monero

ENV XMR_STAK_VERSION v2.0.0
ENV XMR_STAK_URL https://github.com/fireice-uk/xmr-stak.git

# IF SETTING DONATE TO 0 please consider a one time donation to the developer wallet (From donate-level.h)
# 4581HhZkQHgZrZjKeCfCJxZff9E3xCgHGF25zABZz7oR71TnbbgiS7sK9jveE6Dx6uMs2LwszDuvQJgRZQotdpHt1fTdDhk  
ENV DONATE_LEVEL 0.0

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates wget git libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev \
	&& rm -rf /var/lib/apt/lists/* && apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove \

	# grab gosu for easy step-down from root
	&& gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
	&& wget -qO /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

WORKDIR /tmp
RUN set -ex \
	&& git clone $XMR_STAK_URL \
	&& cd xmr-stak \
	&& sed -i -e "s/2\.0/$DONATE_LEVEL/" xmrstak/donate-level.hpp && grep DonationLevel xmrstak/donate-level.hpp \
	&& cmake -DCMAKE_LINK_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DMICROHTTPD_ENABLE=OFF -DOpenSSL_ENABLE=ON -DXMR-STAK_CURRENCY=monero -DXMR-STAK_COMPILE=native -DCPU_ENABLE=ON -DOpenCL_ENABLE=OFF -DCUDA_ENABLE=OFF . \
	&& make install \
	&& cp /tmp/xmr-stak/bin/xmr-stak /usr/bin \
	&& rm -rf /tmp/xmr-stak

RUN set -ex \
	# remove build dependencies
	&& apt-get purge -y --auto-remove wget git

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

