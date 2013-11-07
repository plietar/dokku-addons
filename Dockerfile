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

RUN bash -e -c "\
/etc/init.d/mysql start && sleep 1 && mysql -u root -e \"GRANT ALL ON *.* to root@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;\" && /etc/init.d/mysql stop"

# bind on all adresses
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# change location of persistant files
RUN sed -i -e"s:^\(datadir\s*=\s*\)/var/lib/mysql:\1/opt/mysql:g" /etc/mysql/my.cnf

RUN mkdir -p /opt/mysql
RUN chown -R mysql:mysql /opt/mysql
RUN chmod -R 755 /opt/mysql

ADD start-mariadb.sh /start


