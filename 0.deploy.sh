#!/bin/bash
echo "deploying contracts";
forge script ./script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast

echo "add rewards"
forge script ./script/Rewards.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast

#echo "deposit to vault";
#WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script ./script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d --broadcast
#WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script ./script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a --broadcast
#WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script ./script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356 --broadcast
## WETH=0x5FbDB2315678afecb367f032d93F642f64180aa3 MANAGER=0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 AMOUNT=10 forge script ./script/Deposit.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6 --broadcast