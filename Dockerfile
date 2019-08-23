FROM node:lts-alpine
# Avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1
# Cypress requires write permissions, so let's set the user as ROOT rather than
# messing with adding permissions
USER root
# Setup environment variables for dependencies
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && ALPINE_GLIBC_PACKAGE_VERSION="2.30-r0" \
    && ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
# Install curl so we can grab all the packages we need to install
    && apk add --no-cache --virtual .build-deps curl \
# Grab the glibc packages
    && curl -fsSLO --compressed "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    && apk add --no-cache --allow-untrusted \
# Install the glibc packages
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
# Install Cypress dependencies
        xvfb \
        gtk+3.0-dev \
        libnotify-dev \
        gconf \
        nss \
        libxscrnsaver \
        alsa-lib \
        zlib \
# Install nginx for serving our micro-fe
        nginx \
# Cleanup all build dependencies for glibc
    && apk del .build-deps \
# Remove the installer packages for glibc
    && rm "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
# Set the npm user as root so cypress can install correctly
    && npm config -g set user $(whoami) \
# Install cypress and sonarqube-scanner globally so their binaries are available to use
    && npm i -g cypress sonarqube-scanner
