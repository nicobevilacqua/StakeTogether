// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract VaultManager {
    using Counters for Counters.Counter;
    Counters.Counter internal _vaultId;

    uint256 public constant VAULT_AMOUNT = 32 ether;

    address public immutable vault;

    mapping(uint256 => address) public vaults;

    constructor() {
        vault = address(new Vault());
    }

    function addFunds() external payable {
        require(msg.value > 0, "insufficient funds");
    }

    function createVault() private {
        address newVault = Clones.clone(vault);

        uint256 vaultId = _vaultId.current();
        _vaultId.increment();

        Vault(newVault).initialize(vaultId);

        vaults[vaultId] = newVault;
    }
}
