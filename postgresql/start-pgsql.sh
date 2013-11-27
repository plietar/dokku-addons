#!/usr/bin/env bash
set -exo pipefail

PREFIX=/usr/lib/postgresql/9.1/bin/
DATADIR=/opt/postgresql/data
EXTRA_ARGS="-D $DATADIR -h '*' -c config_file=/etc/postgresql/9.1/main/postgresql.conf"


if [[ ! -d $DATADIR ]]; then
  mkdir -p $DATADIR
  chown postgres:postgres $DATADIR

  PASSWORD=$(</opt/postgresql/PASSWORD)

  su postgres -c "$PREFIX/initdb -D $DATADIR"
  su postgres -c "$PREFIX/postgres --single $EXTRA_ARGS" <<< "ALTER USER postgres WITH PASSWORD '$PASSWORD';"
fi

su postgres -c "$PREFIX/postgres $EXTRA_ARGS"

