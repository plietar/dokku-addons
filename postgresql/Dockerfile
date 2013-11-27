FROM ubuntu:quantal
MAINTAINER Paul Lietar

RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN apt-get update
RUN apt-get upgrade -y

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-9.1 postgresql-contrib-9.1

RUN apt-get clean

# allow autostart again
RUN rm /usr/sbin/policy-rc.d

RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.1/main/pg_hba.conf

RUN mkdir -p /opt/postgresql

ADD start-pgsql.sh /start

CMD ["/start"]
