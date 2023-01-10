#!/bin/bash

. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")

dd if=/dev/mmcblk0 bs=1M status=progress | gzip - | smbclient $SMB_MOUNT -c "cd /$TARGET/;put - $FILE"
