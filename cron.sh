#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")-img.gz

t=$(smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;ls"|grep $NAME-|cut -d \- -f 2)
doit=0
ismonth=$(echo $t| grep -c ^$(date +"%Y%m"))
if [ -z "$t" -o $ismonth > 0 ]; then
  doit=1
fi
let s=$RANDOM%20*100
echo Sleep $s
sleep $s
echo Backup $FILE
dd if=/dev/mmcblk0 bs=1M status=progress | gzip - | smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;put - $FILE"
