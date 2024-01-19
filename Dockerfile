FROM ubuntu:22.04
RUN apt-get update
RUN apt-get -y install python3 python3-dev python3-pip libmagic-dev
RUN apt-get -y install coccinelle
RUN apt install --no-install-recommends -y git cmake ninja-build gperf ccache dfu-util
RUN apt install --no-install-recommends -y device-tree-compiler wget xz-utils file
RUN apt install --no-install-recommends -y make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
RUN pip3 install setuptools
RUN pip3 install wheel
RUN pip3 install python-magic lxml junitparser gitlint pylint pykwalify yamllint unidiff
RUN pip3 install west
RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.4/zephyr-sdk-0.16.4_linux-x86_64.tar.xz
RUN wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.4/sha256.sum | shasum --check --ignore-missing
RUN tar xvf zephyr-sdk-0.16.4_linux-x86_64.tar.xz
RUN cd zephyr-sdk-0.16.4; ./setup.sh -h -t aarch64-zephyr-elf -t arm-zephyr-eabi
RUN mkdir /zephyr/; git config --global --add safe.directory /zephyr/zephyr
