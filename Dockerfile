FROM node:lts-buster-slim
# CI=1 - Avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
# DBUS_SESSION_BUS_ADDRESS=/dev/null - "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
# TERM=xterm - good colors for most applications
# npm_config_loglevel=warn - avoid million NPM install messages
# npm_config_unsafe_perm=true - allow installing when the main user is root
ENV CI=1 DBUS_SESSION_BUS_ADDRESS=/dev/null TERM=xterm npm_config_loglevel=warn npm_config_unsafe_perm=true
# Cypress requires write permissions, so let's set the user as ROOT rather than
# messing with adding permissions
USER root
# Download chrome package for cypress
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
# DEBIAN_FRONTEND=noninteractive - make sure installing works well on docker
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \
# Install all of cypress, chrome and sonar-scanner dependencies
    && apt-get install -y --no-install-recommends \
      dbus-x11 \
      libgtk-3-0 \
      libnotify-dev \
      libgconf-2-4 \
      libnss3 \
      libxss1 \
      libasound2 \
      xvfb \
      google-chrome-stable \
      zip \
      nginx \
# Clean up some stuff to try to keep docker image smaller (still pretty big)
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
# Set the npm user as root so cypress can install correctly
    && npm config -g set user $(whoami) \
# Install cypress and sonarqube-scanner globally so their binaries are available to use
    && npm i -g cypress@3.8.1 sonarqube-scanner \
# Verify cypress install
    && cypress verify
