#!/bin/bash

source .env;

echo "stake user 1";
sleep 1 && WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a --broadcast

echo "stake user 2";
sleep 1 && WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356 --broadcast
## WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script ./script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6 --broadcast