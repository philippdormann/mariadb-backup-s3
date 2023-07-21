#!/bin/bash

# Date function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

# Variables
: ${DB_HOST:='localhost'}
: ${KEEP_DAYS:=7}
: ${DB_PORT:='3306'}
: ${DB_USER:?'Specify a DB_USER variable'}
: ${DB_PASSWORD:?'You must specify the DB_PASSWORD variable'}
: ${FILE_PREFIX:='backup-'}
: ${S3_BUCKET:?'You must specify the S3_BUCKET variable'}
: ${S3_SERVER:?'You must specify the S3_SERVER variable'}
: ${S3_ACCESS:?'You must specify the S3_ACCESS variable'}
: ${S3_SECRET:?'You must specify the S3_SECRET variable'}

mc alias set myminio ${S3_SERVER} ${S3_ACCESS} ${S3_SECRET}
mc ilm rule add --expire-days ${KEEP_DAYS}  myminio/${S3_BUCKET}
# mc retention set --default GOVERNANCE 7  myminio/${S3_BUCKET}

dobackup() {
    FILENAME=`date +%Y-%m-%d_%H-%M-%S`.sql.gz
    echo "$(get_date) MariaDB backup $FILENAME started"
    mariadb-dump --host=${DB_HOST} --port=${DB_PORT} --user=${DB_USER} --password=${DB_PASSWORD} --all-databases | pigz -9 | mc pipe --tags "type=backup" myminio/${S3_BUCKET}/${FILE_PREFIX}-${FILENAME}
    echo "$(get_date) MariaDB backup $FILENAME completed"
}

if [ -z "$WAIT_SECONDS" ]; then
    dobackup
else
    if [ "$INITIAL_BACKUP" == "yes" ]; then
        dobackup
    fi
    while true; do
        echo "waiting $WAIT_SECONDS seconds until next backup..."
        sleep "$WAIT_SECONDS"
        dobackup
    done
fi