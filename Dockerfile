FROM debian:stretch

LABEL maintainer="ZapataComputing"

ENV CLAMAV_VERSION 0.102.4+dfsg-0+deb9u1

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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

ADD run.sh /

CMD ["/run.sh"]
