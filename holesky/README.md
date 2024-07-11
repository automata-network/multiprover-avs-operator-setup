## Table of Contents <!-- omit in toc -->
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Operator setup](#operator-setup)
  - [Install EigenLayer CLI and register as operator](#install-eigenlayer-cli-and-register-as-operator)
- [Running Multi-Prover AVS](#running-multi-prover-avs)
  - [Clone the setup repository](#clone-the-setup-repository)
  - [Update the configuration](#update-the-configuration)
  - [Deposit into strategies](#deposit-into-strategies)
    - [Multi-Prover AVS restaking requirements](#multi-prover-avs-restaking-requirements)
    - [Restaking on Holesky Testnet](#restaking-on-holesky-testnet)
  - [Opt-in into Multi-Prover AVS](#opt-in-into-multi-prover-avs)
  - [Run the operator node](#run-the-operator-node)
  - [Opt-out from Multi-Prover AVS](#opt-out-from-multi-prover-avs)
- [Monitoring](#monitoring)
- [Prover](#prover)
- [FAQ](#faq)

>
> 💡 Check the [CHANGELOG](./CHANGELOG.md) if you are looking for how to upgrage from old version
>

## Introduction

This guide lays out the requirements and steps to register an operator with EigenLayer and opt-in to running the Multi-Prover AVS on Holesky testnet. Responsibilities of the operator will include sampling and proving batched transactions submitted by Scroll to the base layer.

## Requirements

- 4 CPU
- 8GB Memory
- 100GB SSD
- [EigenLayer CLI](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation)
- [Docker](https://docs.docker.com/engine/install/) and [docker-compose plugin](https://docs.docker.com/compose/install/linux/)
- Ubuntu 20.04 LTS
- 32 ETH or LST on Holesky testnet for staking
- 1 ETH on Holesky testnet for perform the attestation

## Operator setup

>💡 Skip this section if you have already [registered](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation) as a node operator on EigenLayer


### Install EigenLayer CLI and register as operator

Follow [EigenLayer’s guide](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation) to install the EigenLayer CLI and register as an operator.

## Running Multi-Prover AVS

### Clone the setup repository

```bash
git clone https://github.com/automata-network/multiprover-avs-operator-setup.git
```

### Update the configuration
>💡 Please pull the the latest code of main branch if you find that the configurations inside `operator.json.example` doesn’t match the documents below.

```bash
cd multiprover-avs-operator-setup/holesky
cp config/operator.json.example config/operator.json
vim config/operator.json
```

Below are the configs that you **need to provide**:

- **BlsKeyFile**: BLS key generated using EigenLayer CLI, the default path is `~/.eigenlayer/operator_keys/xxx.bls.key.json` , please use absolute path for this configuration.
- **BlsKeyPassword**: Password of the BLS key.
- **AttestationLayerEcdsaKey**: The private key (without the 0x prefix) of an externally owned account (EOA) responsible for submitting the TEE attestation, it is **NOT** the operator's ECDSA key. Please fund 1 holETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.

Below are the configs that we recommend **not to use the default value if possible**:

- **ProverURL**: RPC endpoint of the TEE Prover. The default value is `https://avs-prover-staging.ata.network` , which is a TEE prover run by Automata Network. However, we recommend running your own prover. The guide for how to setup the prover can be found [here](../prover/README.md).

> 💡 We recommend running your own prover, as the TEE prover run by Automata Network will operate in whitelist mode in a future release. When whitelist mode is enabled, please contact us to whitelist your operator IP.

Below are the configs that you can **use the default value**:

- **ETHRpcURL**: Holesky RPC url used to interact with Ethereum Holesky testnet.
- **AttestationLayerRpcURL**: The RPC url of the network that TEE liveness verifier contract is deployed on, which is the Ethereum Holesky testnet.
- **AggregatorURL**: URL of aggregator hosted by Automata team. Aggregator will check validity of TEE prover, aggregator the BLS signature and submit the task to AVS service manager.
- **EigenMetricsIpPortAddress**: The ip + port used to fetch metrics.
- **NodeApiIpPortAddress**: The ip + port used for Eigenlayer node API. Please see [this doc](https://docs.eigenlayer.xyz/eigenlayer/avs-guides/spec/api/) for what you can query.
- **RegistryCoordinatorAddress**: Registry coordinator contracts address of Multi-Prover AVS on Holesky testnet.
- **TEELivenessVerifierAddress**: TEE liveness verifier contracts address on Holesky testnet, which verify the attestation provided by the TEE prover and manage its lifecycle.

### Deposit into strategies

#### Multi-Prover AVS restaking requirements

Multi-Prover AVS supports the following strategies on Holesky:

| Token Symbol  | Token Name | Strategy Address |
| --- | --- | --- |
| ETH | Beacon Ether | 0xbeaC0eeEeeeeEEeEeEEEEeeEEeEeeeEeeEEBEaC0 |
| WETH | Wrapped Ether | [0x80528D6e9A2BAbFc766965E0E26d5aB08D9CFaF9](https://holesky.etherscan.io/address/0x80528D6e9A2BAbFc766965E0E26d5aB08D9CFaF9) |
| sfrxETH | Staked Frax Ether | [0x9281ff96637710Cd9A5CAcce9c6FAD8C9F54631c](https://holesky.etherscan.io/address/0x9281ff96637710Cd9A5CAcce9c6FAD8C9F54631c) |
| mETH | Mantle Staked Ether | [0xaccc5A86732BE85b5012e8614AF237801636F8e5](https://holesky.etherscan.io/address/0xaccc5A86732BE85b5012e8614AF237801636F8e5) |
| osETH | StakeWise Staked Ether | [0x46281E3B7fDcACdBa44CADf069a94a588Fd4C6Ef](https://holesky.etherscan.io/address/0x46281E3B7fDcACdBa44CADf069a94a588Fd4C6Ef) |
| rETH | Rocket Pool Ether | [0x3A8fBdf9e77DFc25d09741f51d3E181b25d0c4E0](https://holesky.etherscan.io/address/0x3A8fBdf9e77DFc25d09741f51d3E181b25d0c4E0) |
| lsETH | Liquid Staked Ether | [0x05037A81BD7B4C9E0F7B430f1F2A22c31a2FD943](https://holesky.etherscan.io/address/0x05037A81BD7B4C9E0F7B430f1F2A22c31a2FD943) |
| stETH | Lido Staked Ether | [0x7D704507b76571a51d9caE8AdDAbBFd0ba0e63d3](https://holesky.etherscan.io/address/0x7D704507b76571a51d9caE8AdDAbBFd0ba0e63d3) |
| ankrETH | Ankr Staked Ether | [0x7673a47463F80c6a3553Db9E54c8cDcd5313d0ac](https://holesky.etherscan.io/address/0x7673a47463F80c6a3553Db9E54c8cDcd5313d0ac) |
| cbETH | Coinbase Staked Ether | [0x70EB4D3c164a6B4A5f908D4FBb5a9cAfFb66bAB6](https://holesky.etherscan.io/address/0x70EB4D3c164a6B4A5f908D4FBb5a9cAfFb66bAB6) |
| ETHx | Stader Staked Ether | [0x31B6F59e1627cEfC9fA174aD03859fC337666af7](https://holesky.etherscan.io/address/0x31B6F59e1627cEfC9fA174aD03859fC337666af7) |

>💡 `0xbeaC0eeEeeeeEEeEeEEEEeeEEeEeeeEeeEEBEaC0` is not a real contract, it is used for Beacon Chain Ether shares.

You will need a minimum of 32 ETH to get started as an operator. Refer to [this guide](https://docs.eigenlayer.xyz/eigenlayer/restaking-guides/restaking-user-guide/stage-2-testnet/obtaining-testnet-eth-and-liquid-staking-tokens-lsts) to get ETH and LST on Holesky testnet.

#### Restaking on Holesky Testnet

>💡 **Skip ahead if you have already restake on Holesky**

Follow [EigenLayer’s restaking guide](https://docs.eigenlayer.xyz/eigenlayer/restaking-guides/restaking-user-guide/) to restake the ETH or LST.

Alternatively, the code and tooling required to restake LST on EigenLayer is also available below(make sure you have already get LST before using the tool):

```bash
# Change the `strategy` and `amount` args accordingly
./run.sh deposit <key path of operator's ECDSA key> -strategy 0x7D704507b76571a51d9caE8AdDAbBFd0ba0e63d3 -amount 32
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.
- `strategy`: Strategy contract address of the LST that you want to stake, the `0x7D704507b76571a51d9caE8AdDAbBFd0ba0e63d3` is the strategy address of `Lido Staked Ether` , you can change it to any [supported strategies](#multi-prover-avs-restaking-requirements).
- `amount`: Amount of LST (determined by the strategy address) you want to stake, here `32` means 32 `Lido Staked Ether`.

### Opt-in into Multi-Prover AVS

>💡 Multi-Prover AVS is in PoA mode during its initial launch phase. Make sure that your ECDSA address is in the allowlist.

```bash
./run.sh opt-in <key path of operator's ECDSA key> -quorums 0,1
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.

If you find `execution revert` inside the logs, please contact us to add your operator ECDSA key to the whitelist.

The following logs confirm that you opt-in the Multi-Prover AVS successfully:

```bash
Enter the password for /root/.eigenlayer/operator_keys/operator.ecdsa.key.json: ************************
2024/05/10 08:51:46 [avsregistry.(*AvsRegistryChainWriter).RegisterOperatorInQuorumWithAVSRegistryCoordinator:writer.go:196][INFO] registering operator with the AVS's registry coordinator avs-service-manager=0x4665Af665df5703445645D243f0FD63eD3b9D132 operator=0x78FDDe7a5006cC64E109aeD99cA7B0Ad3d8687bb quorumNumbers=[0]
2024/05/10 08:51:49 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x27159248a7939b4f0eccf425d368556193a5f0a2f93010b518446d794d40f4ca
2024/05/10 08:51:51 [avsregistry.(*AvsRegistryChainWriter).RegisterOperatorInQuorumWithAVSRegistryCoordinator:writer.go:258][INFO] successfully registered operator with AVS registry coordinator txHash=0x27159248a7939b4f0eccf425d368556193a5f0a2f93010b518446d794d40f4ca avs-service-manager=0x4665Af665df5703445645D243f0FD63eD3b9D132 operator=0x78FDDe7a5006cC64E109aeD99cA7B0Ad3d8687bb quorumNumbers=[0]
2024/05/10 08:51:51 [main.(*OprToolOptIn).FlaglyHandle:main.go:81][INFO] Registered operator with avs registry coordinator, succ: true
2024/05/10 08:51:51 [main.(*OprToolOptIn).FlaglyHandle:main.go:88][INFO] operatorID: 9f018fa5c580cce497c54832c0e955baae268cd2b279c40fc155f37cadcf3df6
```

### Run the operator node

```bash
./run.sh operator
```

To check the status of the operator node, you can use `docker compose ps` to check the status

```bash
docker compose ps
```

You will see that the `multi-prover-operator` is already running

```bash
NAME                      IMAGE                                                       COMMAND                  SERVICE             CREATED             STATUS              PORTS
multi-prover-operator     ghcr.io/automata-network/multi-prover-avs/operator:v0.2.2   "operator -c /config…"   operator            7 seconds ago       Up 6 seconds
```

Use `docker compose logs` to check the logs of operator node

```bash
docker compose logs
```

The following logs confirm that the operator node is running:

```bash
multi-prover-operator  | 2024/06/04 07:01:20 [xtask.NewProverClient:prover_client.go:45][INFO] connecting to prover: https://avs-prover-staging.ata.network ...
multi-prover-operator  | 2024/06/04 07:01:20 [aggregator.NewClient:client.go:20][INFO] connecting to aggregator: https://avs-aggregator-staging.ata.network
multi-prover-operator  | 2024/06/04 07:01:20 [operator.(*Operator).Start:operator.go:113][INFO] starting operator...
multi-prover-operator  | 2024/06/04 07:01:20 [nodeapi.(*NodeApi).Start:nodeapi.go:104][INFO] Starting node api server at address 0.0.0.0:15692
multi-prover-operator  | 2024/06/04 07:01:20 [nodeapi.run.func2:nodeapi.go:238][INFO] node api server running addr=0.0.0.0:15692
multi-prover-operator  | 2024/06/04 07:01:21 [operator.(*Operator).RegisterAttestationReport:operator.go:438][INFO] checking tee liveness... attestationLayerEcdsaAddress=***
multi-prover-operator  | 2024/06/04 07:01:21 [operator.(*Operator).RegisterAttestationReport:operator.go:459][INFO] Operater has registered on TEE Liveness Verifier
multi-prover-operator  | 2024/06/04 07:01:21 [operator.(*Metrics).Serve:metric.go:84][INFO] Prometheus listen on 0.0.0.0:15682
multi-prover-operator  | 2024/06/04 07:01:21 [operator.(*Operator).Start:operator.go:136][INFO] Started Operator... operator info: operatorId=***, operatorAddr=***, operatorG1Pubkey=***, operatorG2Pubkey=***, proverVersion=v0.2.0, fetchTaskWithContext=true
multi-prover-operator  | 2024/06/04 07:01:21 [operator.(*Operator).subscribeTask:operator.go:196][INFO] fetch task: &aggregator.FetchTaskReq{PrevTaskID:0, TaskType:1, MaxWaitSecs:100, WithContext:true}
```

Use `docker compose down` if you want to stop the operator node

```bash
docker compose down
```

### Opt-out from Multi-Prover AVS

Run the following command if you want to opt-out from the Multi-Prover AVS:

```bash
./run.sh opt-out <key path of operator's ECDSA key> -quorums 0,1
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.

The following logs confirm that you opted-out from the Multi-Prover AVS successfully:

```bash
Enter the password for /root/.eigenlayer/operator_keys/operator.ecdsa.key.json: ************************
2024/05/10 08:50:21 [avsregistry.(*AvsRegistryChainWriter).DeregisterOperator:writer.go:312][INFO] deregistering operator with the AVS's registry coordinator
2024/05/10 08:50:23 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x71c0b4994d73422cb1362c197f81c666297f7aff9d091fb9a850db8206a1cdc7
2024/05/10 08:50:25 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x71c0b4994d73422cb1362c197f81c666297f7aff9d091fb9a850db8206a1cdc7
2024/05/10 08:50:27 [avsregistry.(*AvsRegistryChainWriter).DeregisterOperator:writer.go:325][INFO] succesfully deregistered operator with the AVS's registry coordinator txHash=0x71c0b4994d73422cb1362c197f81c666297f7aff9d091fb9a850db8206a1cdc7
2024/05/10 08:50:27 [main.(*OprToolOptOut).FlaglyHandle:main.go:122][INFO] tx: 0x71c0b4994d73422cb1362c197f81c666297f7aff9d091fb9a850db8206a1cdc7, succ: true
```

## Monitoring

We recommend setting up monitoring so that you can detect if your operator node is running as expected. The guide for how to setup monitoring can be found [here](../monitoring/README.md).

## Prover

We recommend running your own prover. The guide for how to setup the prover can be found [here](../prover/README.md).

## FAQ

1. **Why did my operator fail to opt-in the Multi-Prover AVS?**

    Confirm that your operator’s ECDSA key is added to the whitelist. Also, make sure that you have staked at least 32 ETH or LST.

2. **I encountered a insufficient stake error when opting in. What should I do?**

    You may receive `execution reverted: StakeRegistry.registerOperator: Operator does not meet minimum stake` error when running the `./run.sh opt-in` even if you have staked 32 ETH or LST. In that case, just stake more ETH and opt-in again.

    The Multi-Prover AVS requires operators to own at least 32 weighted shares in proportion to the overall staking asset. This error occurs when the amount of ETH staked is not 1:1 to the share staked.

3. **How to solve the `unknown shorthand flag: d in -d` error?**

    Please make sure that the docker-compose is installed in a [plugin](https://docs.docker.com/compose/install/linux/) way.

4. **Why do I receive errors when running the `docker compose xxx` commands?**

    Run `./run.sh` under the `holesky` folder. This will update the ENV variables according to the latest `config/operator.json` file.

5. **There are some weird docker permission errors such as** `docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`

    Make sure that the user you are running the command with have the appropriate permissions, such as being in the `docker` group.

6. **Why do I need to provide the `AttestationLayerEcdsaKey` and fund it with 1 holETH?**

    The `AttestationLayerEcdsaKey` is used to submit attestations to the on-chain verifier. Our calculations indicate the 1 holETH will suffice to cover gas costs for attestation verification over a long period.

    During the initial launch on Holesky testnet, we used the operator's ECDSA key to submit attestations.
    However, we decided to use another EOA to submit attestations now, which is more secure for operators since the operator ECDSA key is not used by the operator node anymore, and you can keep it more securely.

7. **Why do I get the following error when trying to register attestation report?**
    ```bash
    multi-prover-operator  | 2024/05/30 06:28:34 [main.main:main.go:42][FATAL] [operator.(*Operator).registerAttestationReport:381;operator.(*Operator).RegisterAttestationReport:409;operator.(*Operator).Start:127(<address>)] execution reverted
    ```
    There is an update to the contract address for `"TEELivenessVerifierAddress"`. Please double check the address from the updated `config/operator.json.example`.