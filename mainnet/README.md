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
    - [Restaking on Ethereum Mainnet](#restaking-on-ethereum-mainnet)
  - [Opt into Multi-Prover AVS](#opt-into-multi-prover-avs)
  - [Run the operator node](#run-the-operator-node)
  - [Opt out from Multi-Prover AVS](#opt-out-from-multi-prover-avs)
- [Monitoring](#monitoring)
- [FAQ](#faq)


## Introduction

This guide lays out the requirements and steps to register an operator with EigenLayer and opt-in to running the Multi-Prover AVS on Ethereum Mainnet. Responsibilities of the operator will include sampling and proving batched transactions submitted by Scroll to the base layer. 

## Requirements

- 4 CPU
- 8GB Memory
- 100GB SSD
- [EigenLayer CLI](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation)
- [Docker](https://docs.docker.com/engine/install/) and [docker-compose plugin](https://docs.docker.com/compose/install/linux/)
- Ubuntu 20.04 LTS
- 0.03 ETH on Ethereum Mainnet
- 0.02 ETH on Optimism Mainnet

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

```bash
cd multiprover-avs-operator-setup/mainnet
cp config/operator.json.example config/operator.json
vim config/operator.json
```

Below are the configs you **need to provide**:

- **BlsKeyFile**: BLS key generated using EigenLayer CLI, the default path is `~/.eigenlayer/operator_keys/xxx.bls.key.json` . Please use absolute path for this configuration.
- **BlsKeyPassword**: Password of the BLS key.
- **AttestationLayerEcdsaKey**: The private key (without the 0x prefix) of an externally owned account (EOA) responsible for submitting the TEE attestation, it is **NOT** the operator's ECDSA key. Please fund 0.02 Optimism ETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.

Below are the configs that we recommend **not to use the default value if possible**:

- **ProverURL**: RPC endpoint of the TEE Prover. The default value is `https://avs-prover-mainnet1.ata.network:18232` , which is a TEE prover run by Automata Network. However, we recommend running your own prover. The guide for how to setup the prover can be found [here](../prover/README.md).

> 💡 We recommend running your own prover, as the TEE prover run by Automata Network will operate in whitelist mode in a future release. When whitelist mode is enabled, please contact us to whitelist your operator IP.


Below are the configs that you can use as **the default value**:

- **Simulation**: The default value is `false` . In the simulation mode, the operator will not actually process the task.
- **ETHRpcURL**: Ethereum RPC url used to interact with Ethereum Mainnet.
- **AttestationLayerRpcURL**: The RPC url of the network that TEE liveness verifier contract is deployed on. The TEE liveness verifier contract is deployed on Optimism Mainnet during the initial launch.
- **AggregatorURL**: URL of aggregator hosted by Automata team. Aggregator checks the validity of TEE prover, aggregates the BLS signatures and submits the task to the AVS service manager. The verifier is deployed on Optimism Mainnet to reduce the operator's operating overheads (gas fees) when submitting the attestation.
- **EigenMetricsIpPortAddress**: The ip + port used to fetch metrics.
- **NodeApiIpPortAddress**: The ip + port used for Eigenlayer node API. Please see [this doc](https://docs.eigenlayer.xyz/eigenlayer/avs-guides/spec/api/) for what you can query.
- **RegistryCoordinatorAddress**: Registry coordinator contracts address of Multi-Prover AVS on Ethereum Mainnet.
- **TEELivenessVerifierAddress**: TEE liveness verifier contracts runs on Optimism Mainnet, which verifies the attestation provided by the TEE prover and manages its lifecycle.

### Deposit into strategies

#### Multi-Prover AVS restaking requirements

Multi-Prover AVS supports the following strategies on Ethereum Mainnet: 

| Token Symbol  | Token Name | Strategy Address |
| --- | --- | --- |
| ETH | Beacon Ether | 0xbeaC0eeEeeeeEEeEeEEEEeeEEeEeeeEeeEEBEaC0 |
| sfrxETH | Staked Frax Ether | [0x8CA7A5d6f3acd3A7A8bC468a8CD0FB14B6BD28b6](https://etherscan.io/address/0x8CA7A5d6f3acd3A7A8bC468a8CD0FB14B6BD28b6) |
| mETH | Mantle Staked Ether | [0x298aFB19A105D59E74658C4C334Ff360BadE6dd2](https://etherscan.io/address/0x298aFB19A105D59E74658C4C334Ff360BadE6dd2) |
| osETH | StakeWise Staked Ether | [0x57ba429517c3473B6d34CA9aCd56c0e735b94c02](https://etherscan.io/address/0x57ba429517c3473B6d34CA9aCd56c0e735b94c02) |
| rETH | Rocket Pool Ether | [0x1BeE69b7dFFfA4E2d53C2a2Df135C388AD25dCD2](https://etherscan.io/address/0x1BeE69b7dFFfA4E2d53C2a2Df135C388AD25dCD2) |
| lsETH | Liquid Staked Ether | [0xAe60d8180437b5C34bB956822ac2710972584473](https://etherscan.io/address/0xAe60d8180437b5C34bB956822ac2710972584473) |
| stETH | Lido Staked Ether | [0x93c4b944D05dfe6df7645A86cd2206016c51564D](https://etherscan.io/address/0x93c4b944D05dfe6df7645A86cd2206016c51564D) |
| ankrETH | Ankr Staked Ether | [0x13760F50a9d7377e4F20CB8CF9e4c26586c658ff](https://etherscan.io/address/0x13760F50a9d7377e4F20CB8CF9e4c26586c658ff) |
| cbETH | Coinbase Staked Ether | [0x54945180dB7943c0ed0FEE7EdaB2Bd24620256bc](https://etherscan.io/address/0x54945180dB7943c0ed0FEE7EdaB2Bd24620256bc) |
| ETHx | Stader Staked Ether | [0x9d7eD45EE2E8FC5482fa2428f15C971e6369011d](https://etherscan.io/address/0x9d7eD45EE2E8FC5482fa2428f15C971e6369011d) |
| OETH | Origin Staked Ether | [0xa4C637e0F704745D182e4D38cAb7E7485321d059](https://etherscan.io/address/0xa4C637e0F704745D182e4D38cAb7E7485321d059) |
| swETH | Swell Staked Ether | [0x0Fe4F44beE93503346A3Ac9EE5A26b130a5796d6](https://etherscan.io/address/0x0Fe4F44beE93503346A3Ac9EE5A26b130a5796d6) |
| wBETH | Binance Staked Ether | [0x7CA911E83dabf90C90dD3De5411a10F1A6112184](https://etherscan.io/address/0x7CA911E83dabf90C90dD3De5411a10F1A6112184) |

>💡 `0xbeaC0eeEeeeeEEeEeEEEEeeEEeEeeeEeeEEBEaC0` is not a real contract. It is used for Beacon Chain Ether shares.

You will need a minimum of 0.01 ETH to get started as an operator. 

#### Restaking on Ethereum Mainnet

>💡 **Skip ahead if you have already restake on Ethereum**

>💡 Please refer to [FAQ #2](https://www.notion.so/Automata-Multi-Prover-AVS-Mainnet-Operator-Guide-c97ce084638e47038a00123946045859?pvs=21) if you encounter `Operator does not meet minimum stake requirement for quorum` error.

Follow [EigenLayer’s restaking guide](https://docs.eigenlayer.xyz/eigenlayer/restaking-guides/restaking-user-guide/) to restake the ETH or LST. 

Alternatively, the code and tooling required to restake LST on EigenLayer is also available below(make sure you have already get LST before using the tool): 

```bash
# Change the `strategy` and `amount` args accordingly
./run.sh deposit <key path of operator's ECDSA key> -strategy 0xa4C637e0F704745D182e4D38cAb7E7485321d059 -amount 0.015
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.
- `strategy`: Strategy contract address of the LST that you want to stake, the `0xa4C637e0F704745D182e4D38cAb7E7485321d059` is the strategy address of `Origin Staked Ether` , you can change it to any [supported strategies](#multi-prover-avs-restaking-requirements).
- `amount`: Amount of LST (determined by the strategy address) you want to stake, here `0.015` means 0.015 `Origin Staked Ether`.

### Opt into Multi-Prover AVS

>💡 Multi-Prover AVS is in PoA mode during its initial launch phase. Make sure that your ECDSA address is in the allowlist.

```bash
./run.sh opt-in <key path of operator's ECDSA key>
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.

If you find `execution revert` inside the logs, contact us to add your operator ECDSA key to the whitelist.

The following logs confirm that you have opted into the Multi-Prover AVS successfully:

```bash
2024/04/16 09:39:13 [avsregistry.(*AvsRegistryChainWriter).RegisterOperatorInQuorumWithAVSRegistryCoordinator:writer.go:196][INFO] registering operator with the AVS's registry coordinator avs-service-manager=0xE5445838C475A2980e6a88054ff1514230b83aEb operator=0x0BeaB1616e132768963C9004754E023F62299E10 quorumNumbers=[0]
2024/04/16 09:39:18 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x6b9652bd1e5b2ddad600232563a5fc70d461c01558895d2f0780667b97142cd4
2024/04/16 09:39:21 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x6b9652bd1e5b2ddad600232563a5fc70d461c01558895d2f0780667b97142cd4
2024/04/16 09:39:22 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x6b9652bd1e5b2ddad600232563a5fc70d461c01558895d2f0780667b97142cd4
2024/04/16 09:39:24 [avsregistry.(*AvsRegistryChainWriter).RegisterOperatorInQuorumWithAVSRegistryCoordinator:writer.go:258][INFO] successfully registered operator with AVS registry coordinator txHash=0x6b9652bd1e5b2ddad600232563a5fc70d461c01558895d2f0780667b97142cd4 avs-service-manager=0xE5445838C475A2980e6a88054ff1514230b83aEb operator=0x0BeaB1616e132768963C9004754E023F62299E10 quorumNumbers=[0]
2024/0416 09:39:24 [main.(*OprToolOptIn).FlaglyHandle:main.go:74][INFO] Registered operator with avs registry coordinator
2024/04/16 09:39:24 [main.(*OprToolOptIn).FlaglyHandle:main.go:81][INFO] operatorID: fb0ecf29f5ce1be4705e56a97c028659a668f154f1d1ff42d51218572ff85f47
```

### Run the operator node

```bash
./run.sh operator
```

Use `docker compose ps` to check the status of the operator node:

```bash
docker compose ps
```

You should see that the `multi-prover-operator-mainnet` is up and running:

```bash
NAME                      IMAGE                                                       COMMAND                  SERVICE             CREATED             STATUS              PORTS
multi-prover-operator-mainnet     ghcr.io/automata-network/multi-prover-avs/operator:v0.1.1   "operator -c /config…"   operator            7 seconds ago       Up 6 seconds
```

Use `docker compose logs` to check the logs of operator node:

```bash
docker compose logs
```

The following logs confirm that the operator node is running:

```bash
multi-prover-operator-mainnet  | 2024/04/16 14:56:41 [operator.ParseConfigContext:operator.go:80][INFO] connecting to https://ethereum-rpc.publicnode.com...
multi-prover-operator-mainnet  | 2024/04/16 14:56:41 [operator.ParseConfigContext:operator.go:85][INFO] connecting to https://optimism-rpc.publicnode.com...
multi-prover-operator-mainnet  | 2024/04/16 14:56:41 [operator.ParseConfigContext:operator.go:100][INFO] build clients clients.BuildAllConfig{EthHttpUrl:"https://ethereum-rpc.publicnode.com", EthWsUrl:"wss://ethereum-rpc.publicnode.com", RegistryCoordinatorAddr:"0x414696E4F7f06273973E89bfD3499e8666D63Bd4", OperatorStateRetrieverAddr:"0x0000000000000000000000000000000000000000", AvsName:"multi-prover-operator", PromMetricsIpPortAddress:"0.0.0.0:15682"}
multi-prover-operator-mainnet  | 2024/04/16 14:56:43 [operator.NewProverClient:prover_client.go:45][INFO] connecting to prover: https://avs-prover-mainnet1.ata.network:18232 ...
multi-prover-operator-mainnet  | 2024/04/16 14:56:43 [aggregator.NewClient:client.go:20][INFO] connecting to aggregator: https://avs-aggregator.ata.network
multi-prover-operator-mainnet  | 2024/04/16 14:56:43 [operator.(*Operator).Start:operator.go:306][INFO] starting operator...
multi-prover-operator-mainnet  | 2024/04/16 14:56:43 [operator.(*Operator).RegisterAttestationReport:operator.go:454][INFO] checking tee liveness...
multi-prover-operator-mainnet  | 2024/04/16 14:56:44 [operator.(*Operator).RegisterAttestationReport:operator.go:468][INFO] Operater has registered on TEE Liveness Verifier
multi-prover-operator-mainnet  | 2024/04/16 14:56:44 [operator.(*Operator).Start:operator.go:321][INFO] Started Operator... operator info: operatorId=fb0ecf29f5ce1be4705e56a97c028659a668f154f1d1ff42d51218572ff85f47, operatorAddr=0x0BeaB1616e132768963C9004754E023F62299E10, operatorG1Pubkey=E([8133121261180865326391242379521587030201441070205549897769321753098540518239,12354059871397247181596143488980666128073678827609478552776966970968728095637]), operatorG2Pubkey=E([8045091577526964514115548952346393534775913087138534391196469717772783244169+18342797848162923711928053069612362066485879591289591227565606908308670652933*u,4882938050112704922608105874428645251618397472269115004313418801412696759477+7198578061496195361206641589060625697600729866425150299713458616307483204986*u])
multi-prover-operator-mainnet  | 2024/04/16 14:56:44 [operator.(*Operator).RegisterAttestationReport.func1:operator.go:487][INFO] next attestation will be at 2024-05-01 14:44:39 +0000 UTC
multi-prover-operator-mainnet  | 2024/04/16 14:56:44 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0xd059aeea4c36aa6710d09da0921bb296022416f9133ee844f7c69fe2c6f9a3f5
multi-prover-operator-mainnet  | 2024/04/16 14:56:45 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0xe78b3161bd168f975ea918a1aee23ea402884f081ab23fa14ef4f525a23227cb
multi-prover-operator-mainnet  | 2024/04/16 14:56:46 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0xea9c9dd2e01373420b57568c3336a2e405520467ca53af26f95ed9c792884ddb
multi-prover-operator-mainnet  | 2024/04/16 14:56:46 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x3e49ac60d7a576167774eabdba6e845a804a021c8af98efea3438a7fe9769ab9
multi-prover-operator-mainnet  | 2024/04/16 14:56:47 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x8af02045d39cfabf8a76c657747578f11d479961a85e3b82fc34206a954759f0
multi-prover-operator-mainnet  | 2024/04/16 14:56:47 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x82e91a0c4a154ba6fa3b2d707c0cb6907232cf5f0fa8e89939884d13b1150c54
multi-prover-operator-mainnet  | 2024/04/16 14:56:47 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x23afd1060415ad6bbbb9960eb8c14a43dddc9b0143693207fb046989b6f38b3a
multi-prover-operator-mainnet  | 2024/04/16 14:56:48 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x9d15c6c44e21c059a1f900a70890d5f3cd723f7d8a7535938ed0e18aa3928589
multi-prover-operator-mainnet  | 2024/04/16 14:56:48 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x381501b7019979560b9406800a4fa9b1f79e0c5a4c2f3119320f641c9ea11d47
multi-prover-operator-mainnet  | 2024/04/16 14:56:48 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x99e6255ef53f764fad1037005a2b7708647925fd6ff82a39493794d2ad213f0b
multi-prover-operator-mainnet  | 2024/04/16 14:56:49 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x1279dc4ffb0b819a5d30503d844a23702a13348f2c53e473c8b54c9601a035e9
multi-prover-operator-mainnet  | 2024/04/16 14:56:49 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x3ddd0d6a8f88d2ac41901ecb175bfbace9f973837aeb580b201a05260cdb43c9
multi-prover-operator-mainnet  | 2024/04/16 14:56:49 [operator.(*LogTracer).Run:log_trace.go:134][INFO] [operator-log-tracer] scan 19668715 -> 19668773, logs: 12
multi-prover-operator-mainnet  | 2024/04/16 14:57:01 [operator.(*LogTracer).Run:log_trace.go:134][INFO] [operator-log-tracer] scan 19668774 -> 19668775, logs: 0
multi-prover-operator-mainnet  | 2024/04/16 14:57:26 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0x7de7e3c4dfe0498cfd77815074c6aa0dd4c9157f967ebee7b86411a8c5378195
multi-prover-operator-mainnet  | 2024/04/16 14:57:27 [operator.(*LogTracer).Run:log_trace.go:134][INFO] [operator-log-tracer] scan 19668776 -> 19668777, logs: 1
multi-prover-operator-mainnet  | 2024/04/16 14:57:51 [operator.(*LogTracer).Run:log_trace.go:134][INFO] [operator-log-tracer] scan 19668778 -> 19668779, logs: 0
multi-prover-operator-mainnet  | 2024/04/16 14:58:16 [operator.(*Operator).proverGetPoe:operator.go:404][INFO] fetching poe for batch 0xd34738341042ad733d2ff27d89551b46c1867c09c1cd69b33eff36c6fdccf08b
multi-prover-operator-mainnet  | 2024/04/16 14:58:16 [operator.(*LogTracer).Run:log_trace.go:134][INFO] [operator-log-tracer] scan 19668780 -> 19668781, logs: 1
```

Use `docker compose down` if you want to stop the operator node:

```bash
docker compose down
```

### Opt out from Multi-Prover AVS

Run the following command if you want to opt out from the Multi-Prover AVS:

```bash
./run.sh opt-out <key path of operator's ECDSA key>
```

- `key path of operator's ECDSA key` : the path to the operator’s ECDSA key, for example, `~/.eigenlayer/operator_keys/operator.ecdsa.key.json`.

The following logs confirm that you have opted out from the Multi-Prover AVS successfully:

```bash
2024/04/16 09:43:56 [avsregistry.(*AvsRegistryChainWriter).DeregisterOperator:writer.go:312][INFO] deregistering operator with the AVS's registry coordinator
2024/04/16 09:44:09 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x196d2e1c543da56945cff142f6edb3fcd25ce0a290171343310f39afcf611979
2024/04/16 09:44:11 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x196d2e1c543da56945cff142f6edb3fcd25ce0a290171343310f39afcf611979
2024/04/16 09:44:13 [txmgr.(*SimpleTxManager).queryReceipt:txmgr.go:143][INFO] Transaction not yet mined txID=0x196d2e1c543da56945cff142f6edb3fcd25ce0a290171343310f39afcf611979
2024/04/16 09:44:15 [avsregistry.(*AvsRegistryChainWriter).DeregisterOperator:writer.go:325][INFO] succesfully deregistered operator with the AVS's registry coordinator txHash=0x196d2e1c543da56945cff142f6edb3fcd25ce0a290171343310f39afcf611979
2024/04/16 09:44:15 [main.(*OprToolOptOut).FlaglyHandle:main.go:110][INFO] Tx: 0x196d2e1c543da56945cff142f6edb3fcd25ce0a290171343310f39afcf611979, Succ: true
```


## Monitoring

We recommend setting up monitoring so that you can detect if your operator node is running as expected. The guide for how to setup monitoring can be found [here](../monitoring/README.md).


## FAQ

1. **Why did my operator fail to opt into the Multi-Prover AVS?**
    
    Confirm that your operator’s ECDSA key is added to the whitelist. Also, make sure that you have staked at least 0.01 ETH or LST.
    
2. **I encountered a insufficient stake error when opting in. What should I do?**
    
    You may receive `execution reverted: StakeRegistry.registerOperator: Operator does not meet minimum stake` error when running the `./run.sh opt-in` even if you have staked 0.01 ETH or LST. In that case, just stake more ETH and opt-in again. 
    
    The Multi-Prover AVS requires operators to own at least 0.01 weighted shares in proportion to the overall staking asset. This error occurs when the amount of ETH staked is not 1:1 to the share staked. 
    
3. **How do I solve the `unknown shorthand flag: `d` in -d` error?**
    
    Make sure that the docker-compose is installed in a [plugin](https://docs.docker.com/compose/install/linux/) way.
    
4. **Why did I receive errors when running the `docker compose xxx` commands?**
    
    Run `. ./docker-compose-env.sh` under the `multiprover-avs-operator-setup` folder. This will update the ENV variables according to the latest `config/operator.json` file.
    
5. **I ran into docker permission errors such as** `docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock.`**How can I fix it?** 
    
    Make sure that the user you are running the command with has the appropriate permissions, such as being in the `docker` group.
6. **Why do I need to provide the `AttestationLayerEcdsaKey` and fund it with 0.02 optimism ETH?**
    
    The `AttestationLayerEcdsaKey` is used to submit attestations to the on-chain verifier. Each submission requires approximately 0.0002 OP ETH and expires in two weeks. Our calculations indicate the 0.02 OP ETH will suffice to cover gas costs for attestation verification over an approximate period of 2 years.
    
    Using another EOA instead of the operator private ECDSA key to submit attestations is more secure to operators since the operator ECDSA key is not used by the operator node anymore and you can keep it more securely.
    
    During the initial implementation of the Multi-Prover AVS, Optimism will function as the attestation layer to help lower gas fees.