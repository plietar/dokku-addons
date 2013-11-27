#!/usr/bin/env bash
set -exo pipefail

DATADIR=/opt/mysql/data
EXTRA_ARGS="--datadir=$DATADIR --user=mysql --console --bind=0.0.0.0"

if [[ ! -d $DATADIR ]]; then
  mkdir -p $DATADIR
  chown mysql:mysql $DATADIR

  init=$(mktemp)
  EXTRA_ARGS="$EXTRA_ARGS --init-file=$init"
  PASSWORD=$(</opt/mysql/PASSWORD)

  mysql_install_db --user=mysql --datadir=$DATADIR

  cat > $init <<EOF
GRANT ALL ON *.* to root@'%' WITH GRANT OPTION;
SET PASSWORD FOR root = PASSWORD('$PASSWORD');
FLUSH PRIVILEGES;
EOF

  chmod 600 $init
  chown mysql:mysql $init
fi

mysqld $EXTRA_ARGS 

