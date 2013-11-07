#!/usr/bin/env bash
set -eo pipefail

/etc/init.d/mysql start

tail -f /var/log/mysql.log &
tail -f /var/log/mysql.err >&2
