FROM willfarrell/letsencrypt:latest

LABEL version=1.0 name="letsencrypt.route53"
LABEL maintainer "garcia.rodriguez.william@gmail.com"

COPY config /etc/dehydrated/config
COPY dehydrated-route53.hook /usr/bin/dehydrated

RUN apk update \
 && apk add jq --no-cache \
 && pip install --upgrade --user awscli \
 && chmod +x /usr/bin/dehydrated

CMD ["dehydrated","-h"]
