#!/bin/bash -e

. ./helper.sh

cmd=$1
shift
key=$1
if [[ "$key" == "" ]]; then
	key="~/.eigenlayer/operator_keys/operator.ecdsa.key.json"
else
	shift
fi

if [ "$cmd" = "opt-in" ]; then
	. ./docker-compose-env.sh $key
	_oprtool optin $key "$@"
elif [ "$cmd" = "opt-out" ]; then
	. ./docker-compose-env.sh $key
	_oprtool optout $key "$@"
elif [ "$cmd" = "deposit" ]; then
	. ./docker-compose-env.sh $key
	_oprtool deposit $key "$@"
elif [ "$cmd" = "operator" ]; then
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
else
  echo "Invalid command"
fi
