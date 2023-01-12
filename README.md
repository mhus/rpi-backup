
The script will do a backup of the Raspberry PI SD card while the system is running and stream 
the data to a samba share. A cronjob script will do a backup every month.

The data will be compressed with gzip.

## Prerequisite

The following commands are required to run the script:

```
git gzip smbclient dd
```

## Install

Clone the repository to /root or another directory as root user. Copy the rpi-backup-config.sh file from
the repository into the parent directory (/root) and fill the variables.

## Automatic Backups

Edit crontab as root (```crontab -e```) and add the following line. It will try for backup every day at 7 o'clock.

```sh
0 7 * * * /root/rpi-backup/cron.sh >/root/rpi-backup.log 2>&1
```

## Usage

Use the script ```backup_now.sh``` to create a backup with current time and date timestamp.

## Variables

* **NAME** The default name of the backup is the hostname. With NAME you can customize the filename prefix.
* **SMB_MOUNT** (Mandatory) The Windows mount point //host/share
* **TARGET** (Mandatory) The target path where the file should be stored
* **USER** (Mandatory) User or user and password for the Windows share "user%password"
* **DD_BS** The DD block size, default 100M
* **SMB_PROTOCOL** The used SMB protocol, default SMB3
* **SMB_BUFFER** The smbclient buffer size, default 1024000
* **AUTO_UPDATE** Set to 'yes' if you trust the source repository and check for an update every time the ```cron.sh``` will be executed.

## Start and end scripts

If you create the scripts ```rpi-backup-start.sh``` and/or ```rpi-backup-end.sh``` the scripts will be executed before and after the backup. It's possible to start/stop services or create SQL dumps for the backup.

## Problems

* The ```smbclient``` command will fail with NT_STATUS_CONNECTION_DISCONNECTED for some unknown reasons, sometimes. The configuration of SMB_BUFFER is set to minimize the issues. For bad network connections the file transfer could fail. If the command was not successful the script tries to remove the file after fail. This could fail too because of "NT_STATUS_SHARING_VIOLATION deleting remote file".
* The script will do a backup of the filesystem while services are running. This could produce inconsistent data. If you run a sql server you should create a sql backup or stop/start the service while backup.
