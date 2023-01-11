#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")-img.gz

removeFile() {
  echo "Remove File"
  sleep 30
  smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;del $FILE"   
}

echo $(date +"%Y-%m-%d %H-%M-%S") Backup $FILE
dd if=/dev/mmcblk0 bs=100M | gzip - | smbclient -U $USER --max-protocol=SMB3 -b 1024000 $SMB_MOUNT -c "cd /$TARGET/;put - $FILE" || removeFile
echo $(date +"%Y-%m-%d %H-%M-%S") Finished
