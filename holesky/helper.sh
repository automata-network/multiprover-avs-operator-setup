#!/bin/bash

function _oprtool() {
	network=""
	if [[ "$NETWORK" != "" ]]; then
		network="--network $NETWORK"
	fi
	blsKey=$(_get_key config/operator.json BlsKeyFile)
	ecdsaKey=$(_get_key config/operator.json EcdsaKeyFile)
	docker run \
	--rm \
	--volume ./config/operator.json:/app/config/operator.json \
	--volume $(_expand_host $blsKey):$(_expand_docker $blsKey) \
	--volume $(_expand_host $ecdsaKey):$(_expand_docker $ecdsaKey) \
	$network \
	ghcr.io/automata-network/multi-prover-avs/oprtool:latest \
	"$@" -config /app/config/operator.json
}

function _expand_host() {
	bash -c "ls $1"
}

function _expand_docker() {
	echo $1 | sed 's/^~\//\/root\//g'
}

function _get_key() {
	file=$1
	key=$2
	cat $1 | grep '\"'$key'\":' | awk -F'"' '{print $(NF-1)}'
}
