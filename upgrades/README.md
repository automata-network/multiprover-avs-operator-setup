# Software Upgrades

## Table of Contents <!-- omit in toc -->
- [Introduction](#introduction)
- [General Flow](#general-flow)
- [Version Specific Changes](#version-specific-changes)
  - [Version 0.2.0](#version-020)


## Introduction
If you are currently running an older version of the operator and its corresponding components, this guide will cover how to upgrade to the newer version.

## General Flow
If you are running your operator using docker compose, you can upgrade with the following steps.

1. First pull the latest copy of this repo:

```bash
cd holesky
# or
cd mainnet

git pull
```

2. Please check [the section below](#version-specific-changes) for the specific changes you need to make per version before starting your services again.

3. Stop the the existing services:

```bash
docker compose down
```

4. Now, restart the service:
```bash
docker compose up -d
```


## Version Specific Changes

### Version 0.2.0

**Required updates** to `operator.json` for both holesky and mainnet:
- Add `"NodeApiIpPortAddress": "0.0.0.0:15692",`
- Update `"TEELivenessVerifierAddress": "0x2E8628F6000Ef85dea615af6Da4Fd6dF4fD149e6"`

**Optional updates** to `operator.json` for both holesky and mainnet:
- Remove `"TaskFetcher": { ... }`
- Remove `"ETHWsURL": "wss://ethereum-holesky-rpc.publicnode.com", `
- Remove `"Simulation": false,`

**Other updates**:
- We have also included monitoring dashboards in this release. Please feel free to use them to monitor your node and services.


Please restart your containers after pulling an updated copy of this repository.
