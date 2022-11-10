#!/usr/bin/env bash

set -x

write_results_to_db() {
    echo "insert into list (date, target, start_time, end_time, status) values (\"$1\", \"$2\", \"$3\", \"$4\", \"$5\");" | mysql -h localhost -u backup_script -p"${db_backups_password}" backups
}

script_dir=$(dirname "$(readlink -f "$0")")
. "${script_dir}"/.env
container_name="${container_name}"
db_backups_password="${db_backups_password}"
mounted_backups_directory="${mounted_backups_directory}"
backups_directory_app="${backups_directory_app}"
backups_directory_secrets="${backups_directory_secrets}"

date=$(date -I)
target="${target}"
start_time=$(date +"%T")

docker exec -t "${container_name}" gitlab-backup create && \
docker exec -t "${container_name}" gitlab-ctl backup-etc --backup-path /secret/gitlab/backups/ && \
end_time=$(date +"%T")

if [[ $? -eq 0 ]]; then
    status="success"

    last_backup=$(ls -t ${mounted_backups_directory} | head -1)
    mv ${mounted_backups_directory}/"${last_backup}" ${backups_directory_app}

    find ${backups_directory_app} -mtime +3 -delete
    find ${backups_directory_secrets} -mtime +3 -delete
else
    status="fail!"
fi

write_results_to_db "${date}" "${target}" "${start_time}" "${end_time}" "${status}"
