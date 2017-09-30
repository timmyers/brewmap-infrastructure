FROM hashicorp/terraform:light

RUN apk update \
 && apk add jq \
 && apk add ansible \
 && rm -rf /var/cache/apk/*
