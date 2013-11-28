.PHONY: all install copyfiles

all:

install: copyfiles

copyfiles:
	mkdir -p /var/lib/dokku/addons
	cp -R mariadb postgresql redis /var/lib/dokku/addons

vagrant:
	ssh -i ~/.vagrant.d/insecure_private_key vagrant@dokku.me sudo make install -C /vagrant/addons

