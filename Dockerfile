FROM node:15.3-alpine3.12
LABEL maintainer="Deokgyu Yang <secugyu@gmail.com>" \
      description="Lightweight Docusaurus container with Node.js 15 based on Alpine Linux 3.12"

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/main/ \
    bash bash-completion supervisor \
    autoconf automake build-base libtool nasm

# Environments
ENV TARGET_UID=1000
ENV TARGET_GID=1000
ENV AUTO_UPDATE='true'
ENV WEBSITE_NAME='MyWebsite'
ENV TEMPLATE='classic'
ENV RUN_MODE='development'

# Create Docusaurus directory and change working directory to that
RUN mkdir /docusaurus
WORKDIR /docusaurus

# Copy configuration files
ADD config/init.sh /
ADD config/auto_update_crontab.txt /
ADD config/auto_update_job.sh /
COPY config/supervisord-dev.conf /etc/supervisor/conf.d/supervisord-dev.conf
COPY config/supervisord-prod.conf /etc/supervisor/conf.d/supervisord-prod.conf

# Set files permission
RUN chmod a+x /init.sh /auto_update_job.sh

EXPOSE 80
VOLUME [ "/docusaurus" ]
ENTRYPOINT [ "/init.sh" ]
