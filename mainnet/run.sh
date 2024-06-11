#!/bin/bash -e

. ./helper.sh

cmd=$1
shift
ecdsa_key=$1
if [[ "$ecdsa_key" != "" ]]; then
	shift
fi

if [ "$cmd" = "opt-in" ]; then
	_require_ecdsa_key "$ecdsa_key"
	. ./docker-compose-env.sh
	_oprtool optin $ecdsa_key "$@"
elif [ "$cmd" = "opt-out" ]; then
	_require_ecdsa_key "$ecdsa_key"
	. ./docker-compose-env.sh
	_oprtool optout $ecdsa_key "$@"
elif [ "$cmd" = "deposit" ]; then
	_require_ecdsa_key "$ecdsa_key"
	. ./docker-compose-env.sh
	_oprtool deposit $ecdsa_key "$@"
elif [ "$cmd" = "operator" ]; then
	. ./docker-compose-env.sh
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
else
  echo "Invalid command"
fi
