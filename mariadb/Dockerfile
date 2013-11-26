FROM ubuntu:quantal
MAINTAINER Paul Lietar

RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1BB943DB
RUN echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu quantal main' > /etc/apt/sources.list.d/mariadb.list
RUN apt-get update

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server-5.5

RUN apt-get clean

# allow autostart again
RUN rm /usr/sbin/policy-rc.d

RUN mkdir -p /opt/mysql
RUN chown -R mysql:mysql /opt/mysql
RUN chmod -R 755 /opt/mysql

ADD start-mariadb.sh /start

CMD ["/start"]
