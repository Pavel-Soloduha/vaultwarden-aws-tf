#!/bin/bash
home_dir="/home/ec2-user"
scripts_path="$home_dir/scripts"

bash $scripts_path/update.sh

docker-compose -f $home_dir/docker-compose.yml down

bash $scripts_path/backup.sh

rm $home_dir/nginx/access.log
touch $home_dir/nginx/access.log

rm $home_dir/nginx/error.log
touch $home_dir/nginx/error.log

chown -R ec2-user:ec2-user $home_dir

rm $home_dir/vw-data/vaultwarden.log
touch $home_dir/vw-data/vaultwarden.log

docker-compose -f $home_dir/docker-compose.yml up -d

shutdown -r now
