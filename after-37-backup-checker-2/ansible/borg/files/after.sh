#!/usr/bin/env bash

set -x

script_dir=$(dirname "$(readlink -f "$0")")
. "${script_dir}"/.env
db_host="${db_host}"
db_backups_password="${db_backups_password}"

date=$(date -I)
target="${target}"
end_time=$(date +"%T")
status="success"

echo "update list set end_time=\"${end_time}\", status=\"${status}\" where date=\"${date}\" and target=\"${target}\"" | mysql -h "${db_host}" -u backup_script -p"${db_backups_password}" backups
