
crontab -e

0 7 * * * /root/rpi-backup/cron.sh >/root/rpi-backup.log 2>&1

