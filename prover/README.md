## Table of Contents
- [Overview](#overview)
- [Setup server to run TEE prover](#setup-server-to-run-the-tee-prover)
- [Setup TEE prover](#setup-tee-prover)
    - [Setup TEE prover using image](#setup-prover-using-image)
    - [Setup TEE prover from source code](#setup-prover-from-source-code)
- [Verify the prover](#verify-the-prover)

## Overview
The article describes how to set up a TEE prover used by Automata Multi-Prover AVS operator and upgrade the operator node to use your own TEE prover.

## Setup server to run the TEE prover
> 💡 The steps below introduce how to set up a Standard_DC4s_v3 virtual machine on Azure, if you already have a server that supports Intel SGX and DCAP, you can skip this section. Please contact us if you decide to use your own server since we need more info about your sever to get the attestation verification pass.

1. Login to [Microsoft Azure portal](https://portal.azure.com/#home) and click the `Virtual machines` service.
2. Create → Azure virtual machine.
    1. Create a new resource group or reuse an existing one.
    2. Fill the necessary basic info.
    3. Choose `Ubuntu Server 20.04 LTS - x64 Gen2` as the basic image.
    4. Choose any region which supports `Standard_DC4s_v3` VM size, and select the `Standard_DC4s_v3` size.
    5. Keep the rest of the configuration as their default settings.
3. Download the ssh key during the setup, modify the permission to 400 and ssh to the vm.

```bash
$ chmod 400 <the pem file downloaded during the setup>
```

## Setup TEE prover

### Setup prover using image
> 💡 Skip this part if you want to build the prover from source code

1. Clone the setup repo and enter the `mainnet` or `holesky` folder
```bash
$ git clone https://github.com/automata-network/multiprover-avs-operator-setup

$ cd multiprover-avs-operator-setup/prover/mainnet
# or
$ cd multiprover-avs-operator-setup/prover/holesky
```

2. Update the configuration
```bash
$ cp config/prover.json.example config/prover.json
$ vim config/prover.json
```

Below are the configs you **need to provide**:
- **l2:** the endpoint of scroll, for example: `http://localhost:8545` , this should be the endpoint of archive node since the prover need to fetch the states from archive node to compute the proof, typically, the RPC methods with `scroll_` prefix are required.
- **server.tls**: the path of tls cert and key, for exmaple, the default value of this config is `/a/b/c`, which means the prover will try to load the `/a/b/c.crt` and `/a/b/c.key`.

3. Run the sgx prover
```bash
$ ./run.sh docker
# or
$ ./run.sh docker -d # running in background
```

### Setup prover from source code
> 💡 Skip this part if you want to run the prover using the provided image

#### Setup the Intel SGX environment
1. Clone the setup repo and setup the SGX environment.
```bash
$ git clone https://github.com/automata-network/multiprover-avs-operator-setup
$ cd multiprover-avs-operator-setup/prover/scripts
$ sudo ./sgx_install_deps.sh
```

#### Build prover from source
1. Clone the latest prover code and switch to the `avs` branch
```bash
$ git clone https://github.com/automata-network/sgx-prover.git
$ cd sgx-prover
$ git checkout avs
```

2. Switch to the root user, and compile the code
```bash
$ sudo su -
$ . ~/.bashrc
$ BUILD=1 RELEASE=1 ./scripts/prover.sh
```

Below are the configs you **need to provide**:
- **l2:** the endpoint of scroll, for example: `http://localhost:8545` , this should be the endpoint of archive node since the prover need to fetch the states from archive node to compute the proof, typically, the RPC methods with `scroll_` prefix are required.
- **server.tls**: the path of tls cert and key, for exmaple, the default value of this config is `/a/b/c`, which means the prover will try to load the `/a/b/c.crt` and `/a/b/c.key`.

3. Run the sgx prover
```bash
$ ./run.sh binary
```

## Verify the prover
Use the following curl command to verify the prover is running in the SGX environment, use https if you configure the tls connection:

```bash
$ curl -k http://localhost:port -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":1,"method":"generateAttestationReport","params":["0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"]}'

Expected result
$ {"jsonrpc":"2.0","result":"<the dcap attestation quote hex string>","id":1}
```