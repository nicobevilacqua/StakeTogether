#!/bin/bash
source ../../.env;

echo "deploying contracts";
forge script ../Deploy.s.sol --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast;

echo "add rewards";
forge script ../Rewards.s.sol --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast;
