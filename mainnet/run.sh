#!/bin/bash -e

. $(dirname $0)/../utils/helper.sh
cd $(dirname $0)
_init_run

cmd=$1
if [[ "$cmd" == "" ]]; then
	_available_cmd $0
fi
shift

if [ "$cmd" = "opt-in" ]; then
	_oprtool optin "$@"
elif [ "$cmd" = "opt-out" ]; then
	_oprtool optout "$@"
elif [ "$cmd" = "deposit" ]; then
	_oprtool deposit "$@"
elif [ "$cmd" = "operator" ]; then
	_operator_config_check
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
else
	echo "Invalid command"
	_available_cmd $0
fi
