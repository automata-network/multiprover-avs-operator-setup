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
cd mainnet

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

* Updated Automata Attestation Layer to the latest

<details>
<summary>Upgrade prover to v0.5.1</summary>

```bash
$ git pull
$ cd prover/mainnet
$ docker compose up -d
```

</details>

<details>
<summary>Upgrade operator to v0.5.1</summary>

```bash
$ git pull
$ cd mainnet
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
$ cd prover/mainnet
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

<details>
<summary>(optional) Switch to Automata Attestation Layer</summary>

### (optional) Switch to Automata Attestation Layer

An option is provided to switch the Attestation Layer to [Automata mainnet](https://explorer.ata.network).
Please make sure you have sufficient balance before making the switch. 

* [Automata Mainnet](https://docs.ata.network/protocol/mainnet)
* [Automata Mainnet Bridge](https://bridge.ata.network/)


**How to switch to Automata Attestation Layer:**
* Add `"AttestationLayerProfile": "automata",` to `operator.json`
* Leave `AttestationLayerProfile` blank to default to `optimism`

</details>



## Version 0.2

<details>


### Operator Configuation Updates <!-- omit in toc -->

**Required updates** to `operator.json`:
- Add `"NodeApiIpPortAddress": "0.0.0.0:15693",`
- Update `"TEELivenessVerifierAddress": "0x99886d5C39c0DF3B0EAB67FcBb4CA230EF373510"`

**Recommended updates** to `operator.json`: <!-- omit in toc -->
- Update `AttestationLayerEcdsaKey`: If you are currently using your operator's ECDSA private key for this, it is recommended to change it to use a separate externally owned account (EOA). Please fund 1 holETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.


**Optional updates** to `operator.json`: <!-- omit in toc -->
- Remove `"TaskFetcher": { ... }`
- Remove `"ETHWsURL": "wss://ethereum-rpc.publicnode.com", `
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

1. Check whether the `TEELivenessVerifierAddress` in config updated to `0x99886d5C39c0DF3B0EAB67FcBb4CA230EF373510`
2. Check whether the balance of the `AttestationLayerEcdsaKey` is enough for sending a transaction

</details>
