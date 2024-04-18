#!/bin/bash

SCRIPT_DIR=$(dirname $0)

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
	ghcr.io/automata-network/multi-prover-avs/oprtool:v0.1.0 \
	"$@" -config /app/config/operator.json
}

function _init_run() {
	../scripts/docker-compose-env.sh
}

function _require_file() {
	if [[ -f "$1" ]]; then
		echo -n
	else
		echo "error: file $1 is required" >&2
		exit 1
	fi
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

function _prover_check() {
	_require_file ./config/prover.json
	tls=$(_get_key ./config/prover.json tls)
	if [[ "$tls" != "" ]]; then
		if [[ ! "$tls" =~ ^"config" ]]; then
			echo "$tls.key $tls.crt should be placed in the config folder" >&2
			return 1
		fi
		_require_file $tls.key
		_require_file $tls.crt
	fi
}

function _available_cmd() {
	echo "Available command:"
	cat $(basename $1) | grep 'if \[' | awk -F'"' '{print $4}' | grep -v '^$' | awk '{print "\t'$0' "$0}'
	return 1
}
