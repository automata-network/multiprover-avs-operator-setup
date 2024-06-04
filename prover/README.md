## Table of Contents <!-- omit in toc -->
- [Overview](#overview)
- [1. Setup server to run the TEE prover](#1-setup-server-to-run-the-tee-prover)
- [2. Certificate Private Key Format](#2-certificate-private-key-format)
- [3. Setup TEE prover](#3-setup-tee-prover)
  - [3.1 Setup prover using Docker image](#31-setup-prover-using-docker-image)
  - [3.2 Setup prover from source code](#32-setup-prover-from-source-code)
    - [Setup the Intel SGX environment](#setup-the-intel-sgx-environment)
    - [Build prover from source](#build-prover-from-source)
- [4. Verify that the prover works](#4-verify-that-the-prover-works)
- [5. Set the Operator "ProverURL" config](#5-set-the-operator-proverurl-config)
- [Setup the Scroll Archive Node](#setup-the-scroll-archive-node)
- [Security Recommendations](#security-recommendations)
- [FAQs](#faqs)

## Overview
The article describes how to set up a TEE prover used by Automata Multi-Prover AVS operator and upgrade the operator node to use your own TEE prover.

Running your own `TEE prover` and `scroll archive node` will be an important indicator for determining reward amounts in the future.

## 1. Setup server to run the TEE prover
> 💡 The steps below introduce how to set up a Standard_DC4s_v3 virtual machine on Azure. If you already have a server that supports Intel SGX and DCAP, you can skip this section. Please contact us if you decide to use your own server since we need more info about your sever to get the attestation verification pass.

1. Login to [Microsoft Azure portal](https://portal.azure.com/#home) and click the `Virtual machines` service.
2. Create → Azure virtual machine.
    1. Create a new resource group or reuse an existing one.
    2. Fill the necessary basic info.
    3. Choose `Ubuntu Server 20.04 LTS - x64 Gen2` as the basic image.
    4. Choose any region which supports `Standard_DC4s_v3` VM size, and select the `Standard_DC4s_v3` size.
    5. Keep the rest of the configurations as their default settings.
3. Download the ssh key during the setup, modify the permission to 400 and ssh to the vm.

```bash
$ chmod 400 <the pem file downloaded during the setup>
```

## 2. Certificate Private Key Format
> 💡 If you are planning to host the prover on the same server as the operator, you can use HTTP and skip this section.

- When generating the certificate for your prover server, make sure that the private key type is RSA and not ECDSA or ED25519.

- Make sure the private key is also in PEM format and not DER format.

- The private key also needs to begin in `-----BEGIN RSA PRIVATE KEY-----`. If needed, convert the key using the following command:

```
openssl rsa -inform PEM -outform PEM -in tls.key -out tls.key
```


## 3. Setup TEE prover

### 3.1 Setup prover using Docker image
> 💡 Skip this part if you want to build the prover from source code

<details>


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

If using HTTPS, also move your cert and key into the config folder.

```json
{
    "l2": "<Scroll Mainnet Archive Node RPC endpoint>",
    "l2_chain_id": 534352,
    "server": {
        "tls": "/a/b/c"
    }
}

Below are the configs that you **need to provide**:

```
* **l2**:
  * the endpoint of scroll, for example: `http://localhost:8545`.
  * To setup the scroll archive node, please check this guide: [Setup the Scroll Archive Node](#setup-the-scroll-archive-node)
  * If you cannot run the Scroll Archive Node, you can remove the **l2** field, but this may affect your final rewards.

* **server.tls**:
  * the path to the tls cert and key.
  * Leave as an empty string if not using HTTPS. Our scripts assume that the cert and key are inside the config folder, and that the cert and key have the same basename. For example, if the the path is set to `config/tls`, the prover will then try to load `./config/tls.crt` and `./config/tls.key`.

3. Run the sgx prover
```bash
$ ./run.sh docker
# or
$ ./run.sh docker -d # to run in the background
```

---

</details>

### 3.2 Setup prover from source code

> 💡 Skip this part if you want to run the prover using the provided docker image

<details>


#### Setup the Intel SGX environment
1. Clone the setup repo and setup the SGX environment.
```bash
$ git clone https://github.com/automata-network/multiprover-avs-operator-setup
$ cd multiprover-avs-operator-setup/prover/scripts
$ sudo ./sgx_install_deps.sh
```

#### Build prover from source
1. Change to the prover directory and clone the latest sgx-prover code and switch to the `avs` branch
```bash
$ cd ..
$ git clone -b avs https://github.com/automata-network/sgx-prover.git
$ cd sgx-prover
```

2. Switch to the root user, and compile the code
```bash
$ sudo -s
$ . ~/.bashrc
$ BUILD=1 RELEASE=1 ./scripts/prover.sh
```

3. Now, go to either the `mainnet` or `holesky` folder and copy over the sgx-prover and sgx_prover_enclave binary.

```bash
$ cd ../mainnet
# or
$ cd ../holesky

$ cp ../sgx-prover/bin/sgx/target/release/sgx-prover sgx_prover
$ cp ../sgx-prover/bin/sgx/target/release/sgx_prover_enclave.signed.so .
```


4. Update the configuration
```bash
$ cp config/prover.json.example config/prover.json
$ vim config/prover.json
```

If using HTTPS, also move your cert and key into the config folder.


```json
{
    "l2": "<Scroll Mainnet Archive Node RPC endpoint>",
    "l2_chain_id": 534352,
    "server": {
        "tls": "/a/b/c"
    }
}
```

Below are the configs that you **need to provide**:

* **l2**:
  * the endpoint of scroll, for example: `http://localhost:8545`.
  * To setup the scroll archive node, please check this guide: [Setup the Scroll Archive Node](#setup-the-scroll-archive-node)
  * If you cannot run the Scroll Archive Node, you can remove the **l2** field, but this may affect your final rewards.

* **server.tls**:
  * the path to the tls cert and key.
  * Leave as an empty string if not using HTTPS. Our scripts assume that the cert and key are inside the config folder, and that the cert and key have the same basename. For example, if the the path is set to `config/tls`, the prover will then try to load `./config/tls.crt` and `./config/tls.key`.
 
5. Run the sgx prover
```bash
$ ./run.sh binary
```

</details>

## 4. Verify that the prover works
Use the following curl command to verify that the prover is running in the SGX environment successfully (use https instead of http if you configured it):


```bash
$ curl -k http://localhost:18232 -H 'Content-Type: application/json' \
       -d '{"jsonrpc":"2.0","id":1,"method":"prover_metadata"}'
```
Expected result
```json
{"jsonrpc":"2.0","result":{"with_context":false,"version":"v0.2.0"},"id":1}
```


## 5. Set the Operator "ProverURL" config

- If the operator and prover dockers are running on the same host, you can use `http://172.17.0.1:18232` (this is the ip of your host on the docker0 network interface).

- Otherwise please use the public ip of your VM or the DNS name that you have set for it.
  - It's strongly recommended to setup HTTPS for your prover, whitelist only the Public IP of your operator node for the port

## Setup the Scroll Archive Node

To build the Scroll client, please refer to https://github.com/scroll-tech/go-ethereum.

> 💡 We recommend setting up the Scroll node with at least 2 CPU, 8GB RAM and 1~2TB SSD storage.

When the compilation is complete, the client binary, geth, can be found in `build/bin`.
Then, you can run geth using the following command:
```
./geth --datadir /data/mainnet --http --http.api eth,web3,net,scroll -gcmode=archive --scroll --l1.endpoint ${ETH_ENDPOINT}
```

- You can replace `/data/mainnet` with the directory that you intend to put the blockchain data in. We recommend using a filesystem that supports snapshots in case of data corruption.
- As a default, you can use https://ethereum-rpc.publicnode.com as the ETH_ENDPOINT.

**Setting l2 config in prover.json**  
- If running the Scroll Archive node on the same host as the prover, set l2 to http://172.17.0.1:8545
- If running the Scroll Archive node on a different host as the prover, set l2 to the Public IP or DNS name of your archive node (with the correct port number).

> 💡 It's strongly recommended to whitelist only your prover node for accessing the execution node.

## Security Recommendations

- If you plan to host the prover on a different server from the operator, it is strongly recommended to setup HTTPS for your prover. Please see [this step](#2-certificate-private-key-format) regarding the requirements of private key format. You should also whitelist only the Public IP of your operator node for port 18232, and block all other IPs from accessing that port.

- If you plan to host the Scroll archive node, and on a different server from the prover, it is strongly recommended whitelist only the prover node's IP for accessing the execution node.

## FAQs

1. **Why does my container crash with the following error?**

    ```bash
    sgx-prover-avs-holesky  | thread '<unnamed>' panicked at 'index out of bounds: the len is 0 but the index is 0', /root/.cargo/git/checkouts/net-http-rs-161299090de15460/2451885/src/http_server.rs:129:43
    sgx-prover-avs-holesky  | fatal runtime error: failed to initiate panic, error 5
    sgx-prover-avs-holesky  | thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: SGX_ERROR_ENCLAVE_CRASHED', sgx-prover/src/main.rs:38:6
    sgx-prover-avs-holesky  | note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    sgx-prover-avs-holesky exited with code 101

    ```

    This might be due to issues in the private key format. Check that the certificate is not in DER format and it starts with `-----BEGIN RSA PRIVATE KEY-----` and ends with `-----END RSA PRIVATE KEY-----`.



2. **Why do I get an error when I run the curl command?**

    ```bash
    curl: (35) OpenSSL SSL_connect: SSL_ERROR_SYSCALL in connection to localhost:18232
    ```

    If you changed the port numbers from the default, please check that the port numbers match.

3. **Why does my prover container report this error when the operator container tries to connect to it?**
   ```bash
   sgx-prover-avs-holesky  | [2024-05-31 08:12:42.853] [parallel-worker-0] [base::thread:75] [ERROR] - parallel execution fail: task:6146778, info: ResponseError("scroll_getBlockTraceByNumberOrHash(Number(6146778),) -> scroll_types::trace::BlockTrace", JsonrpcErrorObj { code: 32601, message: "the method scroll_getBlockTraceByNumberOrHash does not exist/is not available", data: None })
   ```
   This happens because your RPC provider does not support the RPC calls starting with `scroll_`. You will need to use a different RPC provider or double check the setup of your Scroll archive node.

4. **How long will it take for geth to sync the entire blockchain?**

    It will take approximately 2 weeks.