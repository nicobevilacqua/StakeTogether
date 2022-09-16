// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";
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

    function testFuzz(uint256 _amount) public {
        VaultManager _vaultManager = new VaultManager(address(senseiStake), address(weth));

        address investor = makeAddr("investor");
        deal(address(weth), investor, _amount);

        vm.startPrank(investor);

        weth.approve(address(_vaultManager), _amount);

        if (_amount == 0) {
            vm.expectRevert("insufficient funds");
        }
        _vaultManager.depositToVault(_amount);

        if (_amount == 0) {
            // termina aca si no manda ether
            return;
        }

        address[] memory vaults = _vaultManager.getUserVaults();
        Vault vault = Vault(payable(vaults[0]));

        vm.stopPrank();

        assertEq(vault.balanceOf(investor) + weth.balanceOf(investor), _amount, "investor balance");
    }

    function testCreateNewVault() public {
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

        assertEq(vault.balanceOf(investor1), 10 ether, "investor1 balance");
        assertEq(vault.balanceOf(investor2), 10 ether, "investor2 balance");
        assertEq(vault.balanceOf(investor3), 10 ether, "investor3 balance");
        assertEq(vault.balanceOf(investor4), 2 ether, "investor4 balance");
    }
}
