#!/bin/bash

. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=${FILE:-$NAME-$(date +"%Y%m%d")-img.gz}

t=$(smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;ls"|grep $NAME-|cut -d \- -f 2)
ismonth=$(echo $t|sed 's/ /\n/g'|grep -c ^$(date +"%Y%m"))
if [ -z "$t" -o "$ismonth" == 0 ]; then
  echo "Backup not found"
  echo $t
else
  echo "Backup already done"
  echo $t
  exit 0  
fi

export FILE
./backup_now.sh