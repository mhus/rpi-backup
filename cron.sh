#!/bin/bash
cd "$(dirname "$0")"
. ../rpi-backup-config.sh

git pull

./backup.sh
