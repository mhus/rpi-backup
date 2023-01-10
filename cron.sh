#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")-img.gz

dd if=/dev/mmcblk0 bs=1M status=progress | gzip - | smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;put - $FILE"
