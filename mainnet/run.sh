#!/bin/bash -e

<<<<<<< HEAD
. ./helper.sh
=======
. $(dirname $0)/../utils/helper.sh
cd $(dirname $0)
_init_run
>>>>>>> origin/prover

cmd=$1
if [[ "$cmd" == "" ]]; then
	_available_cmd $0
fi
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
<<<<<<< HEAD
	. ./docker-compose-env.sh
=======
	_operator_config_check
>>>>>>> origin/prover
	docker compose up -d
elif [ "$cmd" = "operator-log" ]; then
	docker compose logs
else
	echo "Invalid command"
	_available_cmd $0
fi
