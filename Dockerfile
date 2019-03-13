FROM balexander85/raspbian-stretch

RUN apt-get -y update && apt-get install -y transmission-cli transmission-common transmission-daemon

