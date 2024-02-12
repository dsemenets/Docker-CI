# Container base image; we use Ubuntu but may want to change version or specify architecture
ARG base_image=ubuntu:22.04
FROM $base_image

# Build host type, x86_64 or aarch64
ARG hosttype=x86_64
# Zephyr SDK version to use (full version here)
ARG zsdk_version=0.16.3
# Zephyr RTOS version to use
ARG zephyr_version=v3.4.0

LABEL maintainer.name="The Xen Project" \
      maintainer.email="xen-devel@lists.xenproject.org"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER root

# build depends
RUN apt-get update && \
    apt-get --quiet --yes install \
       software-properties-common \
       lsb-release \
       autoconf \
       automake \
       bison \
       build-essential \
       ca-certificates \
       ccache \
       chrpath \
       cmake \
       cpio \
       device-tree-compiler \
       dfu-util \
       diffstat \
       dos2unix \
       doxygen \
       file \
       flex \
       g++ \
       gawk \
       gcc \
       gcovr \
       git \
       git-core \
       gnupg \
       gperf \
       gtk-sharp2 \
       help2man \
       iproute2 \
       lcov \
       libcairo2-dev \
       libglib2.0-dev \
       libgtk2.0-0 \
       liblocale-gettext-perl \
       libncurses5-dev \
       libpcap-dev \
       libpopt0 \
       libsdl1.2-dev \
       libsdl2-dev \
       libssl-dev \
       libtool \
       libtool-bin \
       locales \
       make \
       net-tools \
       ninja-build \
       openssh-client \
       parallel \
       pkg-config \
       python3-dev \
       python3-pip \
       python3-ply \
       python3-setuptools \
       python-is-python3 \
       qemu \
       rsync \
       socat \
       srecord \
       sudo \
       texinfo \
       unzip \
       valgrind \
       wget \
       ovmf \
       xz-utils \
       thrift-compiler

RUN python3 -m pip install -U --no-cache-dir pip && \
   pip3 install -U --no-cache-dir wheel setuptools && \
   pip3 install --no-cache-dir pygobject && \
   pip3 install --no-cache-dir \
       -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/main/scripts/requirements.txt \
       -r https://raw.githubusercontent.com/zephyrproject-rtos/mcuboot/main/scripts/requirements.txt \
       GitPython imgtool junitparser numpy protobuf PyGithub \
       pylint sh statistics west && \
   pip3 check

RUN mkdir -p /opt/toolchains && \
    cd /opt/toolchains && \
   wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate \
       https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${zsdk_version}/zephyr-sdk-${zsdk_version}_linux-${hosttype}.tar.xz && \
   tar xf zephyr-sdk-${zsdk_version}_linux-${hosttype}.tar.xz && \
   zephyr-sdk-${zsdk_version}/setup.sh -t all -h -c && \
   rm zephyr-sdk-${zsdk_version}_linux-${hosttype}.tar.xz && \
   /opt/toolchains/zephyr-sdk-${zsdk_version}/setup.sh -c

RUN apt install -y sphinx latexmk rst2pdf texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra
RUN apt-get -y install coccinelle
RUN pip3 install python-magic lxml gitlint pykwalify yamllint unidiff

WORKDIR /builds/rzzp

#run west init -m https://github.com/xen-troops/zephyr --mr main && \
#  west update

run west init -m https://github.com/zephyrproject-rtos/zephyr --mr ${zephyr_version} && \
  west update
