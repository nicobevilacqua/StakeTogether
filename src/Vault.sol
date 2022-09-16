// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract Vault is Initializable, ERC20, ERC20Burnable, ReentrancyGuard {
    uint256 public immutable vaultAmount;
    uint256 public vaultId;

    address public immutable manager;

    bool public locked;

    struct Investor {
        address user;
        uint256 investment;
    }

    event FundsAdded(address indexed investor, uint256 amount, uint256 timestamp);
    event FundsRetired(address indexed investor, uint256 amount, uint256 timestamp);

    constructor(uint256 _vaultAmount, address _manager) ERC20("StakeToguetherToken", "STT") {
        require(_vaultAmount > 0, "Invalid vaultAmount");
        vaultAmount = _vaultAmount;
        manager = _manager;
    }

    function initialize(uint256 _vaultId) external payable initializer {
        vaultId = _vaultId;
    }

    function addFunds() external payable {
        require(msg.value > 0, "invalid investment");
        require(!locked, "vault locked");

        uint256 fundsToReceive = Math.min(vaultAmount - totalSupply(), msg.value);
        require(fundsToReceive > 0, "invalid funds");

        _mint(msg.sender, fundsToReceive);

        if (fundsToReceive < msg.value) {
            Address.sendValue(payable(msg.sender), msg.value - fundsToReceive);
            locked = true;
        }

        emit FundsAdded(msg.sender, fundsToReceive, block.timestamp);
    }

    function retireFunds(uint256 _amount) external nonReentrant {
        require(balanceOf(msg.sender) > _amount, "invalid amount");
        require(!locked, "vault locked");

        Address.sendValue(payable(msg.sender), _amount);

        _burn(msg.sender, _amount);

        emit FundsRetired(msg.sender, _amount, block.timestamp);
    }
}
