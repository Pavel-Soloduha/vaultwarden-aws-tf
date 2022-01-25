#!/bin/bash
home_dir="/home/ec2-user"
cd $home_dir
docker-compose down --volumes

sqlite3 $home_dir/vw-data/db.sqlite3 ".backup '$home_dir/vw-data/backup.sqlite3'"

date_full=$(date --iso-8601)
date_year=$(date +%Y)
date_month=$(date +%m)
date_day=$(date +%d)

tar -c --exclude='db.sqlite3-wal' --exclude='vaultwarden.log' -f backup-$date_full.tar.gz ./vw-data

rm $home_dir/vw-data/backup.sqlite3

mkdir -p backup/latest
mkdir -p backup/$date_year/$date_month/$date_day
cp backup-$date_full.tar.gz backup/backup-latest.tar.gz
mv backup-$date_full.tar.gz backup/$date_year/$date_month/$date_day
aws s3 mv --recursive backup s3://vw-backups-bucket --sse

rm -rf backup

docker-compose up -d