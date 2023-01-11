#!/bin/bash

. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")-img.gz

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

removeFile() {
  echo "Remove File"
  sleep 30
  smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;del $FILE"   
}

echo $(date +"%Y-%m-%d %H-%M-%S") Backup $FILE
dd if=/dev/mmcblk0 bs=100M | gzip - | smbclient -U $USER --max-protocol=SMB3 -b 1024000 $SMB_MOUNT -c "cd /$TARGET/;put - $FILE" || removeFile
echo $(date +"%Y-%m-%d %H-%M-%S") Finished
