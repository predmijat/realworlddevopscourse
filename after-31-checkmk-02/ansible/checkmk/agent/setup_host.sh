#!/usr/bin/env bash

set -x

if [ $# -eq 0 ]; then
    echo "You must provide an argument for host you wish to set up."
    echo "Example: ./setup_host.sh do-p.com"
    exit 1
fi

script_dir=$(dirname "$(readlink -f "$0")")

scp ${script_dir}/check_mk_agent $1:/usr/bin/check_mk_agent
scp ${script_dir}/check-mk-agent@.service ${script_dir}/check-mk-agent.socket $1:/etc/systemd/system/

ssh $1 "systemctl start check-mk-agent.socket && systemctl enable check-mk-agent.socket"
