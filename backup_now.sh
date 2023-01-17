#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=${FILE:-$NAME-$(date +"%Y%m%d-%H%M")-img.gz}
DD_BS=${BS:-100M}
SMB_BUFFER=${SMB_BUFFER:-1024000}
SMB_PROTOCOL=${SMB_PROTOCOL:-SMB3}

removeFile() {
  echo "Remove File"
  sleep 30
  smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;del $FILE"
}

if [ -x ../rpi-backup-start.sh ]; then
  echo $(date +"%Y-%m-%d %H-%M-%S") Backup start script
  ../rpi-backup-start.sh
fi

echo $(date +"%Y-%m-%d %H-%M-%S") Backup to $FILE
dd if=/dev/mmcblk0 bs=$DD_BS | gzip - | smbclient -U $USER -m $SMB_PROTOCOL -b $SMB_BUFFER $SMB_MOUNT -c "cd /$TARGET/;put - $FILE" || removeFile

if [ -x ../rpi-backup-end.sh ]; then
  echo $(date +"%Y-%m-%d %H-%M-%S") Backup end script
  ../rpi-backup-end.sh
fi

echo $(date +"%Y-%m-%d %H-%M-%S") Backup Finished
