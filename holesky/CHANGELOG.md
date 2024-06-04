# Software Upgrades

## Table of Contents <!-- omit in toc -->
- [Introduction](#introduction)
- [General Flow](#general-flow)
- [Version Specific Changes](#version-specific-changes)
  - [Version 0.2.0 (Holesky)](#version-020-holesky)


## Introduction
If you are currently running an older version of the operator and its corresponding components, this guide will cover how to upgrade to the newer version.

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


## Version Specific Changes

### Version 0.2.0 (Holesky)

#### Operator Configuation Updates <!-- omit in toc -->

**Required updates** to `operator.json`:
- Add `"NodeApiIpPortAddress": "0.0.0.0:15692",`
- Update `"TEELivenessVerifierAddress": "0x2E8628F6000Ef85dea615af6Da4Fd6dF4fD149e6"`

**Recommended updates** to `operator.json`: <!-- omit in toc -->
- Update `AttestationLayerEcdsaKey`: If you are currently using your operator's ECDSA private key for this, it is recommended to change it to use a separate externally owned account (EOA). Please fund 1 holETH to this EOA. For your security, we recommend using this EOA for the sole purpose of submitting attestations.


**Optional updates** to `operator.json`: <!-- omit in toc -->
- Remove `"TaskFetcher": { ... }`
- Remove `"ETHWsURL": "wss://ethereum-holesky-rpc.publicnode.com", `
- Remove `"Simulation": false,`

#### Metrics Dashboard <!-- omit in toc -->

We have also included monitoring dashboards in this release. Please feel free to use them to monitor your node and services: [monitoring](../monitoring)

#### SGX Prover <!-- omit in toc -->

In this version, we support running your own SGX Prover. This may be an important criterion for rewards in the future. Please refer to the following link for how to run: [prover](../prover)

### FAQ

* **Why I got this error when I start the operator?**

```
[FATAL] [operator.(*Operator).registerAttestationReport:416(balance:0.1);operator.(*Operator).RegisterAttestationReport:462;operator.(*Operator).Start:120(xxx)] execution reverted
```

1. Check whether the `TEELivenessVerifierAddress` in config updated to `0x2E8628F6000Ef85dea615af6Da4Fd6dF4fD149e6`
2. Check whether the balance of the `AttestationLayerEcdsaKey` is enough for sending a transaction (0.005 holETH)