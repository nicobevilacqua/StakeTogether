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

    constructor(uint256 _vaultAmount) ERC20("StakeToguetherToken", "STT") {
        require(_vaultAmount > 0, "Invalid vaultAmount");
        vaultAmount = _vaultAmount;
        manager = msg.sender;
    }

    function initialize(uint256 _vaultId) external payable initializer {
        vaultId = _vaultId;
    }

    function addFunds() external payable {
        _addFunds(msg.sender);
    }

    function addFunds(address _investor) external payable {
        require(msg.sender == manager, "permision denied");
        _addFunds(_investor);
    }

    function _addFunds(address _investor) private {
        require(msg.value > 0, "invalid investment");
        require(!locked, "vault locked");

        uint256 fundsToReceive = Math.min(vaultAmount - totalSupply(), msg.value);
        require(fundsToReceive > 0, "invalid funds");

        _mint(_investor, fundsToReceive);

        if (fundsToReceive < msg.value) {
            Address.sendValue(payable(_investor), msg.value - fundsToReceive);
            locked = true;
        }

        emit FundsAdded(_investor, fundsToReceive, block.timestamp);
    }

    function retireFunds(uint256 _amount) external payable {
        _retireFunds(msg.sender, _amount);
    }

    function retireFunds(address _investor, uint256 _amount) external payable {
        require(msg.sender == manager, "permision denied");
        _retireFunds(_investor, _amount);
    }

    function _retireFunds(address _investor, uint256 _amount) private nonReentrant {
        require(balanceOf(_investor) > _amount, "invalid amount");
        require(!locked, "vault locked");

        Address.sendValue(payable(_investor), _amount);

        _burn(_investor, _amount);

        emit FundsRetired(_investor, _amount, block.timestamp);
    }
}
