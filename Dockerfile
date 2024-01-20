# Stage 1: Build the Suwayomi-Server app
FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP-NAME_RELEASE
LABEL maintainer="taos15"

# Install dependencies
RUN  apk add -U --upgrade --no-cache curl openjdk8-jre-base tzdata jq

# Create the /config directory
RUN mkdir -p /app/<app-name>

RUN \
  if [ -z ${APP-NAME_RELEASE+x} ];  then \
  APP-NAME_RELEASE=$(curl -sX GET "https://api.github.com/repos/<user>/<repo>/releases/latest" \
  | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
  /tmp/<app-name>.tar.gz -L \
  "<url of the app, use the <APP-NAME_RELEASE> variable fo the version releases>" && \
  tar xzf \
  /tmp/<app-name>.tar.gz -C \
  /app/<app-name>/bin --strip-components=1 && \
  echo "**** cleanup ****" && \
  rm -rf \
  /tmp/*

# Container Labels
LABEL maintainer="Taos15" \
  org.opencontainers.image.title="<app-name>" \
  org.opencontainers.image.authors="https://github.com/taos15" \
  org.opencontainers.image.url="" \
  org.opencontainers.image.source="https://github.com/taos15/tachi-docker" \
  org.opencontainers.image.description="This image is used to start Suwayomi-Server jar executable in a container" \
  org.opencontainers.image.vendor="<user>" \
  org.opencontainers.image.licenses="GPL-3.0"


# copy local files
COPY root/ /

# ports and volumes
EXPOSE 4567
VOLUME /config
