// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";

contract VaultManagerTest is Test {
    address private investor1;
    address private investor2;
    address private investor3;
    address private investor4;
    address private investor5;
    address private investor6;

    VaultManager private vaultManager;

    function setUp() public {
        investor1 = makeAddr("investor1");
        investor2 = makeAddr("investor2");
        investor4 = makeAddr("investor3");
        investor5 = makeAddr("investor4");
        investor6 = makeAddr("investor5");

        vm.deal(investor1, 1000 ether);
        vm.deal(investor2, 1000 ether);
        vm.deal(investor3, 1000 ether);
        vm.deal(investor4, 1000 ether);
        vm.deal(investor5, 1000 ether);
        vm.deal(investor6, 1000 ether);

        vaultManager = new VaultManager();
    }

    function testCreateNewVault() public {
        vm.startPrank(investor1);
        vaultManager.addFunds{value: 10 ether}();
        vm.stopPrank();

        vm.startPrank(investor2);
        vaultManager.addFunds{value: 10 ether}();
        vm.stopPrank();

        vm.startPrank(investor3);
        vaultManager.addFunds{value: 10 ether}();
        vm.stopPrank();

        vm.startPrank(investor4);
        vaultManager.addFunds{value: 10 ether}();
        vm.stopPrank();

        address[] memory vaults = vaultManager.userVaults(investor1);

        assertEq(vaults.length, 1);

        Vault vault = Vault(vaults[0]);

        assertEq(vault.balanceOf(investor1), 10 ether);
        assertEq(vault.balanceOf(investor2), 10 ether);
        assertEq(vault.balanceOf(investor3), 10 ether);
        assertEq(vault.balanceOf(investor4), 2 ether);
    }
}
