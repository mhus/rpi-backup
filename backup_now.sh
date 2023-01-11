#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

NAME=${NAME:-$HOSTNAME}
FILE=$NAME-$(date +"%Y%m%d")-img.gz
DD_BS=${BS:-100M}
SMB_BUFFER=${SMB_BUFFER:-1024000}
SMB_PROTOCOL=${SMB_PROTOCOL:-SMB3}

removeFile() {
  echo "Remove File"
  sleep 30
  smbclient -U $USER $SMB_MOUNT -c "cd /$TARGET/;del $FILE"   
}

echo $(date +"%Y-%m-%d %H-%M-%S") Backup $FILE
dd if=/dev/mmcblk0 bs=$DD_BS | gzip - | smbclient -U $USER --m $SMB_PROTOCOL -b $SMB_BUFFER $SMB_MOUNT -c "cd /$TARGET/;put - $FILE" || removeFile
echo $(date +"%Y-%m-%d %H-%M-%S") Finished
