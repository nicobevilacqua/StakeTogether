#!/bin/bash
echo "fund wallet";
WALLET=0x0000003FA6D1d52849db6E9EeC9d117FefA2e200 AMOUNT=33 forge script ./script/GetEth.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6 --broadcast