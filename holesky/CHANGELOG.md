# Changelog

>
> 💡 Check the [README](./README.md) if you are looking for setup from scratch
>


## Introduction
If you are currently running an older version of the operator and its corresponding components, this guide will cover how to upgrade to the newer version.

<details>
<summary>General Flow</summary>

## General Flow
If you are running your operator using docker compose, you can upgrade with the following steps.

1. First pull the latest copy of this repo:

```bash
cd holesky

git pull
```

2. Please check [the section below](#version-specific-changes) for the specific changes you need to make per version before rebooting your services.

3. Stop the the existing services:

```bash
docker compose down
```

4. Now, restart the service:
```bash
docker compose up -d
```

</details>

## Version 0.5.1

| services    | version          | 
|-------------|------------------|
| scroll node | >= v5.6.0 (no changed) |
| prover      | v0.5.0 -> v0.5.1 |
| operator    | v0.5.0 -> v0.5.1 |

**No configuration changed**

* Supports Automata AttestationLayer: Add `"AttestationLayerProfile": "automata_testnet",` to `operator.json`
* Bug fixes on sgx-prover

<details>
<summary>Upgrade prover to v0.5.1</summary>

```bash
$ git pull
$ cd prover/holesky
$ docker compose up -d
```

</details>

<details>
<summary>Upgrade operator to v0.5.1</summary>

```bash
$ git pull
$ cd holesky
$ docker compose up -d
```

</details>


## Version 0.5.0

| services    | version          | 
|-------------|------------------|
| scroll node | >= v5.6.0 (no changed) |
| prover      | v0.4.5 -> v0.5.0 |
| operator    | v0.4.0 -> v0.5.0 |

**No configuration changed**

* Upgraded the Automata SGX SDK to the latest version, supports the ubuntu 22.04.
* Upgraded the Intel SGX SDK to 2.24.
* Security improvement of attestation layer, make sure the result the operator submits must generated from the SGX prover.
* Fixed the issue where the SGX prover sometimes gets stuck.

<details>
<summary>Upgrade prover to v0.5.0</summary>

```bash
$ git pull
$ cd prover/holesky
$ docker compose up -d
```

</details>

<details>
<summary>Upgrade operator to v0.5.0</summary>

```bash
$ git pull
$ cd holesky
$ docker compose up -d
```

</details>


## Version 0.4.5

| services    | version          | 
|-------------|------------------|
| scroll node | >= v5.6.0 (latest v5.7.0) |
| prover      | v0.4.0 -> v0.4.5   |
| operator    | v0.4.0 (no changed)|

<details>
<summary>Upgrade prover to v0.4.5</summary>

```bash
$ git pull
$ cd prover/holesky
$ docker compose down
$ docker compose up -d
```

</details>

<details>
<summary>Upgrade scroll node to v5.7.0 (minimal v5.6.0)</summary>


*Note:* If you have version 5.6.0, there’s no need to upgrade.  
It is necessary to update the scroll node to [v5.7.0](https://github.com/scroll-tech/go-ethereum/releases/tag/scroll-v5.7.0)  

</details>

## Version 0.4

| services    | version          | 
|-------------|------------------|
| scroll node | v5.5.0 -> v5.6.0 |
| prover      | v0.2.3 -> v0.4.0 |
| operator    | v0.2.0 -> v0.4.0 |

<details>
<summary>Upgrade scroll node to v5.6.0</summary>


It is necessary to update the scroll node to [v5.6.0](https://github.com/scroll-tech/go-ethereum/releases/tag/scroll-v5.6.0)  

</details>

<details>
<summary>Upgrade prover to v0.4.0</summary>

We recommend everyone to upgrade. In this version, we have refactored the sgx-prover and replaced SputnikVM with [revm](https://github.com/scroll-tech/revm).  

</details>

## Version 0.3

<details>

### Support Linea Mainnet

This version adds support for linea. It's optional for operators. If you want to join, you can opt-in to the quorum 1.

* Opt In to Linea Quorum
```bash
$ cd holesky
$ ./run.sh opt-in <key path of operator's ECDSA key> -quorums 1
```
Then restart the operator, and the newly started operator will handle both scroll and linea tasks simultaneously.

* Opt Out to Linea Quorum
```bash
$ cd holesky
$ ./run.sh opt-out <key path of operator's ECDSA key> -quorums 1
```
Then restart the operator, and the newly started operator will not handle the linea tasks.

* For Self-Hosted Prover

It is necessary to update the prover version to 0.3 to support linea.
```bash
$ cd prover/holesky
$ ./run.sh docker -d
$ docker compose logs -f
```

**Note: Since linea is currently in the testing phase, the state required to execute linea blocks will be obtained from the server. At this time, the operator does not need to provide an additional execution node.**

</details>

## Version 0.2

<details>

### Operator Configuation Updates <!-- omit in toc -->

**Required updates** to `operator.json`:
- Add `"NodeApiIpPortAddress": "0.0.0.0:15692",`
- Update `"TEELivenessVerifierAddress": "0x2E8628F6000Ef85dea615af6Da4Fd6dF4fD149e6"`

**Recommended updates** to `operator.json`: <!-- omit in toc -->
- Update `AttestationLayerEcdsaKey`: If you are currently using your operator's ECDSA private key for this, it is recommended to change it to use a separate externally owned account (EOA). Please fund 1 holETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.


**Optional updates** to `operator.json`: <!-- omit in toc -->
- Remove `"TaskFetcher": { ... }`
- Remove `"ETHWsURL": "wss://ethereum-holesky-rpc.publicnode.com", `
- Remove `"Simulation": false,`

### Metrics Dashboard <!-- omit in toc -->

We have also included monitoring dashboards in this release. Please feel free to use them to monitor your node and services: [monitoring](../monitoring)

### SGX Prover <!-- omit in toc -->

In this version, we support running your own SGX Prover. Please refer to the following link for how to run: [prover](../prover)

### FAQ

* **Why I got this error when I start the operator?**

```
[FATAL] [operator.(*Operator).registerAttestationReport:416(balance:0.1);operator.(*Operator).RegisterAttestationReport:462;operator.(*Operator).Start:120(xxx)] execution reverted
```

1. Check whether the `TEELivenessVerifierAddress` in config updated to `0x2E8628F6000Ef85dea615af6Da4Fd6dF4fD149e6`
2. Check whether the balance of the `AttestationLayerEcdsaKey` is enough for sending a transaction (0.005 holETH)

</details>