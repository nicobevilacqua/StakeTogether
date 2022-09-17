// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {console2} from "forge-std/console2.sol";

contract GetEthScript is Script {
    address private wallet;
    uint256 private amount;

    function setUp() public {
        wallet = vm.envAddress("WALLET");
        amount = vm.envUint("AMOUNT");
    }

    function run() public {
        vm.startBroadcast();

        console2.log("sending", amount, "ether to", wallet);

        payable(wallet).transfer(amount * 1 ether);

        vm.stopBroadcast();
    }
}
