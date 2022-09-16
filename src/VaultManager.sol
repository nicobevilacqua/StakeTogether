// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract VaultManager {
    using Counters for Counters.Counter;
    Counters.Counter internal _vaultId;

    uint256 public constant VAULT_AMOUNT = 32 ether;
    address public immutable vaultImplementation;

    address _nextVault;

    mapping(uint256 => address[]) public vaults;
    mapping(address => uint256[]) public userVaults;

    event FundsAdded(address indexed user, uint256 amount, uint256 timestamp);
    event VaultCreated(address indexed vault, uint256 timestamp);

    constructor() {
        vaultImplementation = address(new Vault(VAULT_AMOUNT), address(this));
    }

    function addFunds() external payable {
        require(msg.value > 0, "insufficient funds");

        uint256 userPendingFunds = msg.value;
        while (userPendingFunds > 0) {
            uint256 nextVaultInvestmentAmount = Math.min(
                VAULT_AMOUNT - nextVaultBalance,
                userPendingFunds
            );

            nextVaultInvestors.push(Investor(msg.sender, nextVaultInvestmentAmount));

            if (nextVaultBalance == VAULT_AMOUNT) {
                _createNextVault();
            }

            userPendingFunds -= nextVaultInvestmentAmount;
        }

        emit FundsAdded(msg.sender, msg.value, block.timestamp);
    }

    function _createNextVault() private {
        address newVaultImplementation = Clones.clone(vaultImplementation);

        uint256 vaultId = _vaultId.current();
        _vaultId.increment();

        Investor[] memory _investors = nextVaultInvestors;

        address[] vaultInvestors = Vault(newVaultImplementation).initialize(vaultId, _investors);

        nextVaultBalance = 0;
        delete nextVaultInvestors;

        emit VaultCreated(newVaultImplementation, block.timestamp);
    }
}
