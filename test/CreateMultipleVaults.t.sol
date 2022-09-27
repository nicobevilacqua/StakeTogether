// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";
import {ISenseiStake} from "../src/ISenseiStake.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {ISenseiStake} from "../src/ISenseiStake.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract CreateMultipleVaultsTest is Test {
    address private investor1;

    WETH private weth;

    MockSenseiStake private senseiStake;

    VaultManager private vaultManager;

    uint256 constant VAULT_AMOUNT = 32 ether;

    function setUp() public {
        investor1 = makeAddr("investor1");

        weth = new WETH();

        weth.deposit{value: 100000 ether}();

        deal(address(weth), investor1, 100000 ether);

        senseiStake = new MockSenseiStake();

        vaultManager = new VaultManager(address(senseiStake), address(weth));
    }

    function testCreateMultipleVaults(uint256 _deposit) public {
        if (_deposit == 0 || _deposit > 1000 ether) {
            return;
        }

        uint256 expectedUserVaultsAmount = _deposit / VAULT_AMOUNT;
        if (_deposit % VAULT_AMOUNT > 0) {
          expectedUserVaultsAmount++;
        }
        uint256 expectedTotalVaultsAmount = expectedUserVaultsAmount;

        vm.startPrank(investor1);
        weth.approve(address(vaultManager), _deposit);
        vaultManager.depositToVault(_deposit);
        address[] memory userVaults = vaultManager.getUserVaults();
        vm.stopPrank();

        address[] memory totalVaults = vaultManager.getVaults();

        assertEq(expectedTotalVaultsAmount, totalVaults.length, "Total vaults created");
        assertEq(expectedUserVaultsAmount, userVaults.length, "Total user vaults");
    }
}
