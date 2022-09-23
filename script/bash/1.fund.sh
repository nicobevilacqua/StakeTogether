#!/bin/bash

source ../../.env;

echo "fund wallet";
WALLET=0x0000003FA6D1d52849db6E9EeC9d117FefA2e200 AMOUNT=33 forge script ../GetEth.s.sol --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast;