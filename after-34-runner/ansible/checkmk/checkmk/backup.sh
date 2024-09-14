#!/usr/bin/env bash

set -x

write_results_to_db() {
    echo "insert into list (date, target, start_time, end_time, status) values (\"$1\", \"$2\", \"$3\", \"$4\", \"$5\");" | mysql -h localhost -u backup_script -p"${db_backups_password}" backups
}

script_dir=$(dirname "$(readlink -f "$0")")
. "${script_dir}"/.env
db_backups_password="${db_backups_password}"
service_directory="${service_directory}"
service_backup_directory="${service_backup_directory}"

date=$(date -I)
target="${target}"
start_time=$(date +"%T")

mkdir -p "${service_backup_directory}"
chown root:root "${service_backup_directory}"
chmod 770 "${service_backup_directory}"

cd "${script_dir}" && \
docker-compose down && \
tar -czvf "${service_backup_directory}"/$(date "+%Y-%m-%dT%H-%M-%S").tar.gz "${service_directory}" && \
docker-compose up -d

end_time=$(date +"%T")

if [[ $? -eq 0 ]]; then
    status="success"

    find "${service_backup_directory}" -mtime +8 -delete
else
    status="fail"
fi

write_results_to_db "${date}" "${target}" "${start_time}" "${end_time}" "${status}"
