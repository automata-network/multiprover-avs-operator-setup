#!/bin/bash -e

. $(dirname $0)/../../utils/helper.sh
cd $(dirname $0)

cmd=$1
if [[ "$cmd" == "" ]]; then
	_available_cmd $0
fi
shift

if [ "$cmd" = "docker" ]; then
	_prover_check
	docker compose up "$@"
elif [ "$cmd" = "binary" ]; then
    _prover_check
    rm /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so.1
    ln -s /usr/lib/libdcap_quoteprov.so /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so.1
    unset SGX_AESM_ADDR
    ./sgx_prover -c config/prover.json --disable_check_report_metadata "$@"
else
    echo "Invalid command"
    _available_cmd $0
fi