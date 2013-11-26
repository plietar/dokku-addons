#!/usr/bin/env bash
set -eo pipefail

DATADIR=/opt/redis

if [[ -f $DATADIR/PASSWORD ]]; then
  redis-server --dir $DATADIR --requirepass $(< $DATADIR/PASSWORD)
else
  redis-server --dir $DATADIR
fi

