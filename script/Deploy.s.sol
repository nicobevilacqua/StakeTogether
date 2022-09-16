// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "forge-std/console2.sol";

import {WETH} from "../src/mocks/WETH.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        WETH weth = new WETH();

        console2.log("weth address", address(weth));

        MockSenseiStake senseiStake = new MockSenseiStake();

        console2.log("senseiStake address", address(senseiStake));

        VaultManager vaultManager = new VaultManager(address(senseiStake), address(weth));

        console2.log("vaultManager address", address(vaultManager));

        vm.stopBroadcast();
    }
}
