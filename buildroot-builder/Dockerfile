FROM ubuntu:18.04
MAINTAINER przRocco <primeroznl@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    curl \
    g++ \
    gcc \
    git \
    gzip \
    locales \
    libncurses5-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python \
    rsync \
    sed \
    tar \
    unzip \
    wget \
    && apt-get clean all
    

# Sometimes Buildroot need proper locale, e.g. when using a toolchain
# based on glibc.
RUN locale-gen en_US.utf8

WORKDIR /build

RUN ["/bin/bash"]
