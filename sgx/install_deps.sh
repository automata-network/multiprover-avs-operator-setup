#!/bin/bash  -e

sudo apt update

sudo apt install -y unzip lsb-release debhelper cmake reprepro autoconf automake bison build-essential curl dpkg-dev expect flex gcc-8 gdb git git-core gnupg kmod libboost-system-dev libboost-thread-dev libcurl4-openssl-dev libiptcdata0-dev libjsoncpp-dev liblog4cpp5-dev libprotobuf-dev libssl-dev libtool libxml2-dev ocaml ocamlbuild protobuf-compiler python-is-python3 texinfo uuid-dev vim wget software-properties-common clang perl pkgconf libboost-dev libsystemd0
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /var/lib/apt/lists/packages.microsoft.*
sudo rm -rf /var/lib/apt/lists/download.01.org.*

export rust_toolchain=nightly-2021-11-01
curl 'https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init' --output ./rustup-init && \
    chmod +x ./rustup-init && \
    echo '1' | sudo ./rustup-init --default-toolchain ${rust_toolchain} --profile minimal && \
    echo "source $HOME/.cargo/env" >> ./.bashrc && \
    rm ./rustup-init && rm -rf ./.cargo/registry && rm -rf ./.cargo/git
source $HOME/.cargo/env

wget https://download.01.org/intel-sgx/sgx-linux/2.19/as.ld.objdump.r4.tar.gz && \
    tar xzf as.ld.objdump.r4.tar.gz
sudo cp -r external/toolset/ubuntu20.04/* /usr/bin/
rm -rf ./external ./as.ld.objdump.r4.tar.gz

mkdir /opt/intel
export SDK_URL="https://download.01.org/intel-sgx/sgx-linux/2.19/distro/ubuntu20.04-server/sgx_linux_x64_sdk_2.19.100.3.bin"
curl -o sdk.sh $SDK_URL && chmod a+x ./sdk.sh && echo -e 'no\n/opt/intel' | sudo ./sdk.sh && echo 'source /opt/intel/sgxsdk/environment' >> ~/.bashrc && rm ./sdk.sh
source /opt/intel/sgxsdk/environment
sudo cp -R /opt/intel/sgxsdk /opt/sgxsdk

export CODENAME=focal
export VERSION=2.19.100.3-focal1
export DCAP_VERSION=1.16.100.2-focal1
export AZ_DCAP_CLIENT_VERSION=1.12.0

curl -fsSL  https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo apt-key add - && \
    sudo add-apt-repository "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $CODENAME main" && \
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y \
        libsgx-headers=$VERSION \
        libsgx-ae-epid=$VERSION \
        libsgx-ae-le=$VERSION \
        libsgx-ae-pce=$VERSION \
        libsgx-aesm-ecdsa-plugin=$VERSION \
        libsgx-aesm-epid-plugin=$VERSION \
        libsgx-aesm-launch-plugin=$VERSION \
        libsgx-aesm-pce-plugin=$VERSION \
        libsgx-aesm-quote-ex-plugin=$VERSION \
        libsgx-enclave-common=$VERSION \
        libsgx-enclave-common-dev=$VERSION \
        libsgx-epid=$VERSION \
        libsgx-epid-dev=$VERSION \
        libsgx-launch=$VERSION \
        libsgx-launch-dev=$VERSION \
        libsgx-quote-ex=$VERSION \
        libsgx-quote-ex-dev=$VERSION \
        libsgx-uae-service=$VERSION \
        libsgx-urts=$VERSION \
        sgx-aesm-service=$VERSION \
        libsgx-dcap-ql=$DCAP_VERSION \
        libsgx-dcap-ql-dev=$DCAP_VERSION \
        libsgx-dcap-quote-verify=$DCAP_VERSION \
        libsgx-dcap-quote-verify-dev=$DCAP_VERSION \
        libsgx-dcap-default-qpl=$DCAP_VERSION \
        libsgx-dcap-default-qpl-dev=$DCAP_VERSION \
        libsgx-ae-id-enclave=$DCAP_VERSION \
        libsgx-ae-qve=$DCAP_VERSION \
        libsgx-ae-qe3=$DCAP_VERSION \
        libsgx-ae-tdqe=$DCAP_VERSION \
        libsgx-pce-logic=$DCAP_VERSION \
        libsgx-qe3-logic=$DCAP_VERSION \
        libsgx-ra-network=$DCAP_VERSION \
        libsgx-ra-network-dev=$DCAP_VERSION \
        libsgx-ra-uefi=$DCAP_VERSION \
        libsgx-ra-uefi-dev=$DCAP_VERSION \
        libsgx-tdx-logic=$DCAP_VERSION \
        libsgx-tdx-logic-dev=$DCAP_VERSION \
        sgx-ra-service=$DCAP_VERSION && \
    sudo apt install -y az-dcap-client=$AZ_DCAP_CLIENT_VERSION && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /var/cache/apt/archives/*

export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib
export LD_RUN_PATH=/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/intel/sgxsdk/sdk_libs"
