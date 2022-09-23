#!/bin/bash

source ../../.env;

curl -H "Content-Type: application/json" -X POST --data \
        '{"id":1337,"jsonrpc":"2.0","method":"evm_increaseTime","params":[15552000]}' \
        http://127.0.0.1:8545

curl -H "Content-Type: application/json" -X POST --data \
        '{"id":1337,"jsonrpc":"2.0","method":"evm_mine","params":[]}' \
        http://127.0.0.1:8545