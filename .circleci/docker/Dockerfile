FROM hashicorp/terraform:light

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk update \
 && apk add jq \
 && apk add ansible@edge \
 && rm -rf /var/cache/apk/*
