#!/bin/bash

. ./helper.sh

blsKey=$(_get_key config/operator.json BlsKeyFile)
ecdsaKey=$(_get_key config/operator.json EcdsaKeyFile)

export BLS_KEY_FILE_HOST=$(_expand_host $blsKey)
echo BLS_KEY_FILE_HOST=$BLS_KEY_FILE_HOST
export BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey)
echo BLS_KEY_FILE_DOCKER=$BLS_KEY_FILE_DOCKER
export ECDSA_KEY_FILE_HOST=$(_expand_host $ecdsaKey)
echo ECDSA_KEY_FILE_HOST=$ECDSA_KEY_FILE_HOST
export ECDSA_KEY_FILE_DOCKER=$(_expand_docker $ecdsaKey)
echo ECDSA_KEY_FILE_DOCKER=$ECDSA_KEY_FILE_DOCKER
