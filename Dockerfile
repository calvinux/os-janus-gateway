# --- ÉTAPE 1 : Compilation ---
FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Installer les dépendances de développement pour compiler Janus
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    gengetopt \
    libtool \
    autoconf \
    automake \
    make \
    gcc \
    g++ \
    libmicrohttpd-dev \
    libjansson-dev \
    libssl-dev \
    libsrtp2-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libconfig-dev \
    libnice-dev \
    && rm -rf /var/lib/apt/lists/*

# Cloner et compiler Janus Gateway avec les options allégées
ARG JANUS_GIT_BRANCH=master
ARG JANUS_GIT_REPO=https://github.com/meetecho/janus-gateway.git

RUN git clone --depth=1 -b ${JANUS_GIT_BRANCH} --single-branch ${JANUS_GIT_REPO} /tmp/janus-gateway \
    && cd /tmp/janus-gateway \
    && sh autogen.sh \
    && ./configure \
        --prefix=/opt/janus \
        --disable-rabbitmq \
        --disable-mqtt \
        --disable-linux-sockets \
        --disable-plugin-videoroom \
        --disable-plugin-videocall \
        --disable-plugin-textroom \
        --disable-plugin-streaming \
        --disable-plugin-sip \
        --disable-plugin-recordplay \
        --disable-plugin-nosip \
        --disable-plugin-echotest \
    && make \
    && make install \
    && make configs


# --- ÉTAPE 2 : Image finale légère pour l'exécution ---
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installer uniquement les bibliothèques runtime indispensables (pas de paquets -dev ni de compilateurs)
RUN apt-get update && apt-get install -y \
    libmicrohttpd12 \
    libjansson4 \
    libssl3 \
    libsrtp2-1 \
    libglib2.0-0 \
    libopus0 \
    libogg0 \
    libcurl4 \
    libconfig9 \
    libnice10 \
    && rm -rf /var/lib/apt/lists/*

# Copier l'installation de Janus depuis l'étape de build
COPY --from=builder /opt/janus /opt/janus

WORKDIR /opt/janus

CMD ["/opt/janus/bin/janus"]