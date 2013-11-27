FROM ubuntu:quantal
MAINTAINER Paul Lietar

RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
RUN echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu quantal main" > /etc/apt/sources.list.d/redis-server.list
RUN apt-get update

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install redis-server

RUN apt-get clean

# allow autostart again
RUN rm /usr/sbin/policy-rc.d

RUN mkdir -p /opt/redis

ADD start-redis.sh /start

CMD ["/start"]

