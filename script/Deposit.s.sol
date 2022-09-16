// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "forge-std/console2.sol";

import {WETH} from "../src/mocks/WETH.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract DepositScript is Script {
    VaultManager private vaultManager;
    WETH private weth;
    uint256 private amount;

    function setUp() public {
        vaultManager = VaultManager(vm.envAddress("MANAGER"));
        weth = WETH(payable(vm.envAddress("WETH")));
        amount = vm.envUint("AMOUNT");
    }

    function run() public {
        vm.startBroadcast();

        (bool sent, ) = payable(weth).call{value: amount}("");
        require(sent, "weth wrapping failed");

        weth.approve(address(vaultManager), amount);

        vaultManager.depositToVault(amount);

        vm.stopBroadcast();
    }
}
