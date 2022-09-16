// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Vault is Initializable {
    uint256 public vaultId;

    function initialize(uint256 _vaultId) external initializer {
        vaultId = _vaultId;
    }
}
