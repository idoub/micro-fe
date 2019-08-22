FROM node:lts-alpine
# Cypress requires write permissions, so let's set the user as ROOT rather than
# messing with adding permissions
USER root
# Avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1
RUN npm config -g set user $(whoami) &&\
# Install environment dependencies to alpine linux
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk &&\
    apk add --update gtk+2.0 libnotify gconf nss libxscrnsaver alsa-lib xvfb nginx glibc-2.30-r0.apk --allow-untrusted &&\
    rm -f glibc-2.30-r0.apk &&\
# # Install cypress and sonarqube-scanner globally so their binaries are available
# # to use
    npm i -g cypress sonarqube-scanner
