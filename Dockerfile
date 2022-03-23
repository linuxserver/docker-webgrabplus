FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# package versions
ARG WEBGRAB_VER

# environment variables.
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME /config

RUN \
  echo "**** install dotnet sdk ****" && \
  mkdir -p /app/dotnet && \
  curl -o /tmp/dotnet-install.sh -L \
    https://dot.net/v1/dotnet-install.sh && \
  chmod +x /tmp/dotnet-install.sh && \
  /tmp/dotnet-install.sh -c 5.0 --install-dir /app/dotnet --runtime dotnet && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cron \
    libicu66 \
    unzip && \
  echo "**** install webgrabplus ****" && \
  if [ -z "$WEBGRAB_VER" ]; then \
    WEBGRAB_VER=$(curl -fsL http://webgrabplus.com/download/sw | grep -m1 /download/sw/v | sed 's|.*/download/sw/v\(.*\)">V.*|\1|'); \
  fi && \
  echo "Found Webgrabplus version ${WEBGRAB_VER}" && \
  WEBGRAB_URL=$(curl -fsL http://webgrabplus.com/download/sw/v${WEBGRAB_VER} | grep '>Linux</a>' | sed 's|.*\(http://webgrab.*tar\.gz\).*|\1|') && \
  mkdir -p \
    /app/wg++ && \
  curl -o /tmp/wg++.tar.gz -L \
    "${WEBGRAB_URL}" && \
  tar xzf \
    /tmp/wg++.tar.gz -C \
    /app/wg++ --strip-components=1 && \
  echo "**** download siteini.pack ****" && \
  curl -o \
    /tmp/ini.zip -L \
    http://www.webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip && \
  unzip -q /tmp/ini.zip -d /defaults/ini/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# copy files
COPY root/ /

# ports and volumes
VOLUME /config /data
