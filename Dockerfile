FROM lsiobase/mono
MAINTAINER saarg

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Set correct environment variables.
ENV HOME /config
ARG DEBIAN_FRONTEND="noninteractive"

# install runtime dependencies
RUN \
 apt-get update && \
 apt-get install -y \
	cron && \

# download and extract WG++ to correct paths
 mkdir wg++ && \
 curl -o /tmp/wg++.tar.gz -L \
	http://webgrabplus.com/sites/default/files/download/SW/V2.0.0/WebGrabPlus_V2.0_install.tar.gz && \
 tar xzf /tmp/wg++.tar.gz --strip-components=1 -C /wg++/ && \

# download update
 curl -o /tmp/update.tar.gz -L \
	http://webgrabplus.com/sites/default/files/download/SW/V2.0.7/WebGrabPlus_V2.0.7_beta_install.tar.gz && \
 tar xf /tmp/update.tar.gz --strip-components=2 -C /wg++/bin/ && \

# download Siteini.pack
 curl -o /tmp/ini.zip -L \
	http://webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip && \
 unzip /tmp/ini.zip -d /defaults/ini/ && \

# cleanup
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy files
COPY root/ /

VOLUME /config \
	/data
