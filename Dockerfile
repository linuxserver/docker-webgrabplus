FROM lsiobase/mono
MAINTAINER saarg

# package versions
ARG WEBGRAB_VER="2.0.0"
ARG WGUPDATE_VER="2.0.7_beta"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Set correct environment variables.
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME /config

# install runtime dependencies
RUN \
 apt-get update && \
 apt-get install -y \
	cron && \

# install webgrab
 WEBGRAB_BRANCH=${WEBGRAB_VER%.0} && \
 mkdir -p \
	/app/wg++ && \
 curl -o /tmp/wg++.tar.gz -L \
	"http://webgrabplus.com/sites/default/files/download/SW/V${WEBGRAB_VER}/WebGrabPlus_V${WEBGRAB_BRANCH}_install.tar.gz" && \
 tar xzf \
 /tmp/wg++.tar.gz -C \
	/app/wg++ --strip-components=1 && \

# install wg-update
 WGUPDATE_BRANCH=${WGUPDATE_VER%%_*} && \
 curl -o \
 /tmp/update.tar.gz -L \
	"http://webgrabplus.com/sites/default/files/download/SW/V${WGUPDATE_BRANCH}/WebGrabPlus_V${WGUPDATE_VER}_install.tar.gz" && \
 tar xf \
	/tmp/update.tar.gz -C \
	/app/wg++/bin/ --strip-components=2 && \

# download siteini.pack
 curl -o \
 /tmp/ini.zip -L \
	http://webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip && \
 unzip -q /tmp/ini.zip -d /defaults/ini/ && \

# cleanup
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy files
COPY root/ /

# ports and volumes
VOLUME /config /data
