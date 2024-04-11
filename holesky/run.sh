#!/bin/bash -e

. ./helper.sh

cmd=$1
shift

if [ "$cmd" = "opt-in" ]; then
	_oprtool optin "$@"
elif [ "$cmd" = "opt-out" ]; then
	_oprtool optout "$@"
elif [ "$cmd" = "deposit" ]; then
	_oprtool deposit "$@"
elif [ "$cmd" = "operator" ]; then
	. ./docker-compose-env.sh
	docker compose up
else
  echo "Invalid command"
fi
