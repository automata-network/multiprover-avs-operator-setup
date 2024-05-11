#!/bin/bash

. ./helper.sh

blsKey=$(_get_key config/operator.json BlsKeyFile)

echo > .env
export BLS_KEY_FILE_HOST=$(_expand_host $blsKey)
echo BLS_KEY_FILE_HOST=$(_expand_host $blsKey) >> .env
export BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey)
echo BLS_KEY_FILE_DOCKER=$(_expand_docker $blsKey) >> .env