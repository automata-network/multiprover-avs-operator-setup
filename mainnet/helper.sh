#!/bin/bash

function _oprtool() {
	network=""
	if [[ "$NETWORK" != "" ]]; then
		network="--network $NETWORK"
	fi
	if [[ "$ENTRYPOINT" != "" ]]; then
		ENTRYPOINT="-it --entrypoint $ENTRYPOINT"
	fi
	blsKey=$(_get_key config/operator.json BlsKeyFile)
	cmd=$1
	shift
	key=$(_expand_host $1)
	shift
	if [[ ! -f "$key" ]]; then
		echo "ecdsa key not existed" >&2
		return 1
	fi
	docker run \
	--rm -it \
	--volume ./config/operator.json:/app/config/operator.json \
	--volume $(_expand_host $blsKey):$(_expand_docker $blsKey) \
	--volume $key:$key \
	$network \
	$ENTRYPOINT \
	ghcr.io/automata-network/multi-prover-avs/oprtool:v0.1.2 \
	$cmd -ecdsakeypath $key -config /app/config/operator.json "$@"
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
