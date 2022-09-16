// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";
import {WETH} from "../src/mocks/WETH.sol";
import {ISenseiStake} from "../src/ISenseiStake.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {ISenseiStake} from "../src/ISenseiStake.sol";

contract VaultManagerTest is Test {
    address private investor1;
    address private investor2;
    address private investor3;
    address private investor4;
    address private investor5;
    address private investor6;

    WETH private weth;

    MockSenseiStake private senseiStake;

    VaultManager private vaultManager;

    function setUp() public {
        investor1 = makeAddr("investor1");
        investor2 = makeAddr("investor2");
        investor3 = makeAddr("investor3");
        investor4 = makeAddr("investor4");

        weth = new WETH();

        vm.deal(address(weth), 100000 ether);

        deal(address(weth), investor1, 1000 ether);
        deal(address(weth), investor2, 1000 ether);
        deal(address(weth), investor3, 1000 ether);
        deal(address(weth), investor4, 1000 ether);

        senseiStake = new MockSenseiStake();

        vaultManager = new VaultManager(address(senseiStake), address(weth));
    }

    function testCreateOneVault() public {
        vm.startPrank(investor1);
        weth.approve(address(vaultManager), 10 ether);
        vaultManager.depositToVault(10 ether);
        vm.stopPrank();

        vm.startPrank(investor2);
        weth.approve(address(vaultManager), 10 ether);
        vaultManager.depositToVault(10 ether);
        vm.stopPrank();

        vm.startPrank(investor3);
        weth.approve(address(vaultManager), 10 ether);
        vaultManager.depositToVault(10 ether);
        vm.stopPrank();

        vm.startPrank(investor4);
        weth.approve(address(vaultManager), 10 ether);
        vaultManager.depositToVault(10 ether);
        address[] memory vaults = vaultManager.getUserVaults();
        vm.stopPrank();

        address vaultAddress = vaults[0];
        Vault vault = Vault(payable(vaults[0]));

        assertEq(senseiStake.balanceOf(vaultAddress), 1);
        assertEq(senseiStake.ownerOf(0), vaultAddress, "No es el owner del nft");

        // avanzo 6 meses para que se libere la guita
        vm.warp(block.timestamp + 30 days * 6);
        senseiStake.addRewards{value: 4 ether}(0);
        // cualquiera puede llamar esta funcion
        vault.exitStake();

        assertGt(vault.convertToAssets(vault.balanceOf(investor1)), 10 ether);
        assertEq(
            vault.convertToAssets(vault.balanceOf(investor1)),
            (36 ether * 10 ether) / 32 ether
        );
    }

    receive() external payable {}
    // agarra la pala capo
}