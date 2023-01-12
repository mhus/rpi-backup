#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

if [ "x$AUTO_UPDATE" == "xyes" ]; then
    git pull
fi

./backup.sh
