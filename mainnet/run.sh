#!/bin/bash -e

. ./helper.sh

cmd=$1
shift
key=$1
if [[ "$key" != "" ]]; then
	shift
fi

if [ "$cmd" = "opt-in" ]; then
	ENV=$key _require_env $cmd "<ecdsa key file path>"
	. ./docker-compose-env.sh
	_oprtool optin $key "$@"
elif [ "$cmd" = "opt-out" ]; then
	ENV=$key _require_env $cmd "<ecdsa key file path>"
	. ./docker-compose-env.sh
	_oprtool optout $key "$@"
elif [ "$cmd" = "deposit" ]; then
	ENV=$key _require_env $cmd "<ecdsa key file path>"
	. ./docker-compose-env.sh
	_oprtool deposit $key "$@"
elif [ "$cmd" = "operator" ]; then
	. ./docker-compose-env.sh
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
else
  echo "Invalid command"
fi
