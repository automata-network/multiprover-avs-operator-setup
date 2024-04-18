#!/bin/bash -e

. $(dirname $0)/../scripts/env.sh
cd $(dirname $0)
_init_run

cmd=$1
shift

if [ "$cmd" = "opt-in" ]; then
	_oprtool optin "$@"
elif [ "$cmd" = "opt-out" ]; then
	_oprtool optout "$@"
elif [ "$cmd" = "deposit" ]; then
	_oprtool deposit "$@"
elif [ "$cmd" = "operator" ]; then
	_require_file config/operator.json
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
elif [ "$cmd" = "prover" ]; then
	_require_file config/prover.json
	docker compose -f docker-compose-prover.yaml up "$@"
else
  echo "Invalid command"
fi
