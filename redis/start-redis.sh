#!/usr/bin/env bash
set -eo pipefail

DATADIR=/opt/redis/data

if [[ ! -d $DATADIR ]]; then
  mkdir -p $DATADIR
  chown redis:redis $DATADIR
fi

if [[ -f /opt/redis/PASSWORD ]]; then
  redis-server --dir $DATADIR --requirepass $(< /opt/redis/PASSWORD)
else
  redis-server --dir $DATADIR
fi

