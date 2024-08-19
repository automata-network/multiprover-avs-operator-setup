# Changelog

>
> 💡 Check the [README](./README.md) if you are looking for setup from scratch
>

## Table of Contents <!-- omit in toc -->
- [Introduction](#introduction)
- [General Flow](#general-flow)
- [Version Specific Changes](#version-specific-changes)
  - [Version 0.4](#version-04)
  - [Version 0.2](#version-02)


## Introduction
If you are currently running an older version of the operator and its corresponding components, this guide will cover how to upgrade to the newer version.

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


## Version Specific Changes

### Version 0.4

#### For Self-Hosted Scroll Archive Node

It is necessary to update the scroll node to [v5.6.0](https://github.com/scroll-tech/go-ethereum/releases/tag/scroll-v5.6.0)  


#### For Self-Hosted Prover

We recommend everyone to upgrade. In this version, we have refactored the sgx-prover and replaced SputnikVM with [revm](https://github.com/scroll-tech/revm).  


#### (optional) Automata Attestation Layer

An option is provided to switch the Attestation Layer to [Automata mainnet](https://explorer.ata.network).
Please make sure you have sufficient balance before making the switch. 

* [Mainnet (Preview)](https://docs.ata.network/protocol/mainnet-preview)
* [Automata Mainnet Bridge](https://bridge.ata.network/)


**How to switch to Automata Attestation Layer:**
* Add `"AttestationLayerProfile": "automata",` to `operator.json`
* Leave `AttestationLayerProfile` blank to default to `optimism`



### Version 0.2

#### Operator Configuation Updates <!-- omit in toc -->

**Required updates** to `operator.json`:
- Add `"NodeApiIpPortAddress": "0.0.0.0:15693",`
- Update `"TEELivenessVerifierAddress": "0x99886d5C39c0DF3B0EAB67FcBb4CA230EF373510"`

**Recommended updates** to `operator.json`: <!-- omit in toc -->
- Update `AttestationLayerEcdsaKey`: If you are currently using your operator's ECDSA private key for this, it is recommended to change it to use a separate externally owned account (EOA). Please fund 1 holETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.


**Optional updates** to `operator.json`: <!-- omit in toc -->
- Remove `"TaskFetcher": { ... }`
- Remove `"ETHWsURL": "wss://ethereum-rpc.publicnode.com", `
- Remove `"Simulation": false,`

#### Metrics Dashboard <!-- omit in toc -->

We have also included monitoring dashboards in this release. Please feel free to use them to monitor your node and services: [monitoring](../monitoring)

#### SGX Prover <!-- omit in toc -->

In this version, we support running your own SGX Prover. Please refer to the following link for how to run: [prover](../prover)

### FAQ

* **Why I got this error when I start the operator?**

```
[FATAL] [operator.(*Operator).registerAttestationReport:416(balance:0.1);operator.(*Operator).RegisterAttestationReport:462;operator.(*Operator).Start:120(xxx)] execution reverted
```

1. Check whether the `TEELivenessVerifierAddress` in config updated to `0x99886d5C39c0DF3B0EAB67FcBb4CA230EF373510`
2. Check whether the balance of the `AttestationLayerEcdsaKey` is enough for sending a transaction