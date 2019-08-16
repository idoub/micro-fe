FROM node:lts-alpine
# Cypress requires write permissions, so let's set the user as ROOT rather than
# messing with adding permissions
USER root
RUN npm config -g set user $(whoami)
# Install environment dependencies to alpine linux
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add --update gtk+2.0 libnotify gconf nss libxscrnsaver alsa-lib xvfb nginx glibc-2.29-r0.apk
# Avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1
# Install cypress and sonarqube-scanner globally so their binaries are available
# to use
RUN npm i -g cypress sonarqube-scanner
