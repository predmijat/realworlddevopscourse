#!/usr/bin/env bash

set -x

script_dir=$(dirname "$(readlink -f "$0")")
. "${script_dir}"/.env
db_host="${db_host}"
db_backups_password="${db_backups_password}"

date=$(date -I)
target="${target}"
start_time=$(date +"%T")

echo "insert into list (date, target, start_time) values (\"${date}\", \"${target}\", \"${start_time}\");" | mysql -h "${db_host}" -u backup_script -p"${db_backups_password}" backups
