#!/usr/bin/env bash

set -x

backup_dir="/mnt/storage/backups/mariadb"
db_backup="/mnt/storage/backups/mariadb/dumps-$(date -I)"
db_user="root"
hostname=$(hostname)

mkdir -p "$db_backup"

for db in $(mysql --user=$db_user -e 'show databases' -s --skip-column-names | grep -vi information_schema); do
    mysqldump --user="$db_user" --single-transaction --opt "$db" | gzip > "$db_backup"/mariadb-"$hostname"-"$db"-$(date +%Y-%m-%d).gz;
done

mysqldump --user="$db_user" --opt --single-transaction performance_schema | gzip > "$db_backup"/mariadb-"$hostname"-performance_schema-1-$(date +%Y-%m-%d).gz

list_of_backups=( $(ls "${backup_dir}" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}$") )

for backup in "${list_of_backups[@]}"; do
    if [[ "${backup}" > $(date -I -d "7 days ago") ]]; then
        echo "${backup} is backup from last 7 days, keeping it"
    elif
        [[ $(date -d "${backup}" +%u) == 4 && "${backup}" > $(date -I -d "1 month ago") ]]; then
        echo "${backup} was Thursday and is less than a month old, keeping it"
    elif
        [[ $(date -d "${backup}" +%d) == 01 && "${backup}" > $(date -I -d "1 year ago") ]]; then
        echo "${backup} was first day of month and is less than a year old, keeping it"
    else
        rm -rf "${backup_dir}"/dumps-"${backup}"
    fi
done
