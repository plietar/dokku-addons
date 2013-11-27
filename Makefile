.PHONY: all install copyfiles

all:

install: copyfiles

copyfiles:
	mkdir -p /var/lib/dokku/addons
	cp -R mariadb postgresql redis /var/lib/dokku/addons

