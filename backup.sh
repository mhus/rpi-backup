#!/bin/bash

. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}

t=$(smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;ls"|grep $NAME-|cut -d \- -f 2)
ismonth=$(echo $t| grep -c ^$(date +"%Y%m"))
if [ -z "$t" -o "$ismonth" == 0 ]; then
  echo "Backup not found"
  echo $t
else
  echo "Backup already done"
  echo $t
  exit 0  
fi
./backup_now.sh