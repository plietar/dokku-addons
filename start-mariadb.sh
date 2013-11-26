#!/usr/bin/env bash
set -exo pipefail

DATADIR=/opt/mysql/data
EXTRA_ARGS="--datadir=$DATADIR --user=mysql --console --bind=0.0.0.0"

mkdir -p $DATADIR

if [[ -z "$(ls -A $DATADIR)" ]]; then
  init=$(mktemp)
  EXTRA_ARGS="$EXTRA_ARGS --init-file=$init"
  PASSWORD=$(</opt/mysql/PASSWORD)

  mysql_install_db --user=mysql --datadir=$DATADIR

  cat > $init <<EOF
GRANT ALL ON *.* to root@'%' WITH GRANT OPTION;
SET PASSWORD FOR root = PASSWORD('$PASSWORD');
FLUSH PRIVILEGES;
EOF
  chmod 644 $init
fi

mysqld $EXTRA_ARGS 

