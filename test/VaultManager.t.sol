// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract VaultManagerTest is Test {
    address private lender;

    function setUp() public {
        lender = makeAddr("lender");

        vm.deal(lender, 1000 ether);
    }

    function test() public {}
}
