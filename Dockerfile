# Stage 1: use docker-glibc-builder build glibc.tar.gz
FROM ubuntu:22.04 AS builder
LABEL maintainer="Sasha Gerrand <github+docker-glibc-builder@sgerrand.com>"
# 支持传递 GLIBC_VERSION 参数
ARG GLIBC_VERSION=2.39
ENV DEBIAN_FRONTEND=noninteractive \
    GLIBC_VERSION=${GLIBC_VERSION} \
    PREFIX_DIR=/usr/glibc-compat
RUN apt-get -q update \
    && apt-get -qy install \
    bison \
    build-essential \
    gawk \
    gettext \
    openssl \
    python3 \
    texinfo \
    wget
COPY configparams /glibc-build/configparams 
COPY builder /builder
RUN /builder

# Stage 2: use docker-alpine-abuild package apk and keys
FROM alpine:3.20 AS packager
ARG GLIBC_VERSION=2.39
ARG ALPINE_VERSION=3.20
ARG TARGETARCH
RUN apk --no-cache add alpine-sdk coreutils cmake sudo bash \
    && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
    && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir /packages \
    && chown builder:abuild /packages
COPY ./abuilder /bin/
USER builder
ENV PACKAGER="glibc@gliderlabs.com" 
RUN abuild-keygen -na && sudo cp /home/builder/.abuild/${PACKAGER}-*.rsa.pub /etc/apk/keys/
WORKDIR /home/builder/package
COPY --from=builder /glibc-bin-${GLIBC_VERSION}.tar.gz /home/builder/package/
COPY . /home/builder/package/

ENV REPODEST=/packages
RUN case "$TARGETARCH" in \
    amd64)   export TARGET_ARCH="x86_64" ;; \
    arm64)   export TARGET_ARCH="aarch64" ;; \
    *)       echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    sed -i "s/^pkgver=.*/pkgver=${GLIBC_VERSION}/" APKBUILD && \
    sed -i "s/^arch=.*$/arch=\"${TARGET_ARCH}\"/" APKBUILD && \
    abuild checksum && abuilder -r && cp /packages/builder/${TARGET_ARCH}/*.apk /tmp/

# Stage 3: apk add apk, build alpine-glibc 
FROM alpine:3.20
ARG GLIBC_VERSION=2.39
ARG TARGETARCH
ENV GLIBC_VERSION=${GLIBC_VERSION}
ENV PACKAGER="glibc@gliderlabs.com"

RUN case "$TARGETARCH" in \
    amd64)   export LD_LINUX_PATH="/lib/ld-linux-x86_64.so.2" ;; \
    arm64)   export LD_LINUX_PATH="/lib/ld-linux-aarch64.so.1" ;; \
    *)       echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac

# 复制公钥和 glibc APK 包
COPY --from=packager /tmp/*.apk /tmp/
COPY --from=packager /home/builder/.abuild/${PACKAGER}-*.pub /etc/apk/keys/

# 安装 glibc APK
RUN apk add --no-cache gcompat && rm -rf ${LD_LINUX_PATH} && \
    apk add --no-cache --force-overwrite /tmp/glibc-${GLIBC_VERSION}-*.apk && \
    apk add --no-cache /tmp/glibc-bin-${GLIBC_VERSION}-*.apk && \
    apk add --no-cache /tmp/glibc-i18n-${GLIBC_VERSION}-*.apk && \
    rm -rf /tmp/*.apk

CMD ["/bin/sh"]
