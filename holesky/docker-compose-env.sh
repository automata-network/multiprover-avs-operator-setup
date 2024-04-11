#!/bin/bash

. ./helper.sh

blsKey=$(_get_key config/operator.json .BlsKeyFile)
ecdsaKey=$(_get_key config/operator.json .EcdsaKeyFile)

export BLS_KEY_FILE_HOST=$(_expand_host $blsKey)
export BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey)
export ECDSA_KEY_FILE_HOST=$(_expand_host $ecdsaKey)
export ECDSA_KEY_FILE_DOCKER=$(_expand_docker $ecdsaKey)
