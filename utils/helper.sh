#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)

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
	ghcr.io/automata-network/multi-prover-avs/oprtool:v0.2.0 \
	$cmd -ecdsakeypath $key -config /app/config/operator.json "$@"
}

function _init_run() {
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
}

function _require_file() {
	if [[ -f "$1" ]]; then
		echo -n
	else
		echo "error: file $1 is required! cwd: $(pwd)" >&2
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

function _operator_check() {
	_require_file ./config/operator.json

	blsKey=$(_get_key config/operator.json BlsKeyFile)

	_require_file $(_expand_host $blsKey)
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

function _require_ecdsa_key() {
	if [[ "$1" == "" ]]; then
		echo "Error: You need to provide the ECDSA key to finish this operation"
		return 1
	fi
}