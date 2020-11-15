FROM python:3.9.0-slim-buster
WORKDIR /
RUN apt-get -qq update && \
    apt-get -qq install -y git g++ gcc autoconf automake \
    m4 libtool qt4-qmake make libqt4-dev libcurl4-openssl-dev \
    libcrypto++-dev libsqlite3-dev libc-ares-dev \
    libsodium-dev libnautilus-extension-dev \
    libssl-dev libfreeimage-dev swig
ENV MEGA_SDK_VERSION '3.7.4'
RUN git clone https://github.com/meganz/sdk.git sdk && cd sdk &&\
    git checkout v$MEGA_SDK_VERSION && ./autogen.sh && \
    ./configure --disable-silent-rules --enable-python --disable-examples && \
    make -j$(nproc --all) && cd bindings/python/ && \
    python3 setup.py bdist_wheel && cd dist/ && \
    pip3 install --no-cache-dir megasdk-$MEGA_SDK_VERSION-*.whl
RUN apt-get -qq update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && \
    apt-get -qq install -y p7zip-full p7zip-rar aria2 wget wget2 unzip libxslt-dev curl pv jq ffmpeg locales libxml2 make python-libxslt1 python3-lxml && \
    apt-get -qq upgrade && \
    apt-get purge -y software-properties-common

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
