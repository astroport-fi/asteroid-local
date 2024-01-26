#!/bin/bash
set -e

script_full_path=$(dirname "$0")

export BINARY=gaiad
export CHAINID=gaialocal-1
export P2PPORT=16656
export RPCPORT=16657
export RESTPORT=1316
export ROSETTA=9080
export GRPCPORT=9090
export GRPCWEB=9091
export STAKEDENOM=uatom
export RUN_BACKGROUND=0

"$script_full_path"/start.sh
