FROM debian:stretch

LABEL maintainer="ZapataComputing"

ENV CLAMAV_VERSION 0.102.4+dfsg-0+deb9u2
ENV CLAMAV_MIRROR_URL database.clamav.net

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        clamav-daemon=${CLAMAV_VERSION}* \
        clamav-freshclam=${CLAMAV_VERSION}* \
        ca-certificates \
        openssl \
        dnsutils && \
    mkdir -p /var/run/clamav/ && \
    chgrp clamav /var/run/clamav && \
    chmod g+w /var/run/clamav && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf && \
    sed -i '/^DatabaseMirror/d' /etc/clamav/freshclam.conf

ADD run.sh /

CMD ["/run.sh"]
