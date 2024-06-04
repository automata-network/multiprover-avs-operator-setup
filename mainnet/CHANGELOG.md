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

