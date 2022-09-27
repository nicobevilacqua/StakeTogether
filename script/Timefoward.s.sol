// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {WETH} from "solmate/tokens/WETH.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract DepositScript is Script {
    VaultManager private vaultManager;
    WETH private weth;
    uint256 private amount;

    function setUp() public {
        /*vaultManager = VaultManager(vm.envAddress("MANAGER"));
        weth = WETH(payable(vm.envAddress("WETH")));
        amount = vm.envUint("AMOUNT");
        */
    }

    function run() public {
        vm.startBroadcast();
        vm.warp(block.timestamp + 30 days * 6);
        /*
        uint256 amountETH = amount * 1 ether;

        (bool sent, ) = payable(weth).call{value: amountETH}("");
        require(sent, "weth wrapping failed");

        weth.approve(address(vaultManager), amountETH);

        vaultManager.depositToVault(amountETH);
        */

        vm.stopBroadcast();
    }
}
