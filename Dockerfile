FROM balexander85/raspbian-stretch

RUN apt-get -y update && apt-get install -y transmission-cli transmission-common transmission-daemon

WORKDIR /usr/bin

COPY torrent_cleanup.sh /var/lib/transmission-daemon/info/

EXPOSE 9091

ENV USERNAME=admin
ENV PASSWORD=admin
ENV PORT=9091


VOLUME /downloaded
