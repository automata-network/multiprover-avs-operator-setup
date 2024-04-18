#!/bin/bash

. $(dirname $0)/env.sh

if [[ -f "config/operator.json" ]]; then

	blsKey=$(_get_key config/operator.json BlsKeyFile)
	ecdsaKey=$(_get_key config/operator.json EcdsaKeyFile)

	echo > .env
	export BLS_KEY_FILE_HOST=$(_expand_host $blsKey)
	echo BLS_KEY_FILE_HOST=$(_expand_host $blsKey) >> .env
	export BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey)
	echo BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey) >> .env
	export ECDSA_KEY_FILE_HOST=$(_expand_host $ecdsaKey)
	echo ECDSA_KEY_FILE_HOST=$(_expand_host $ecdsaKey) >> .env
	export ECDSA_KEY_FILE_DOCKER=$(_expand_docker $ecdsaKey)
	echo ECDSA_KEY_FILE_DOCKER=$(_expand_docker $ecdsaKey) >> .env

fi
