// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {ISenseiStake} from "./ISenseiStake.sol";

import  from "solmate/mixins/ERC4626.sol";
no toque mas

import "forge-std/console2.sol";

contract VaultCopy is Initializable, ERC20, ERC20Burnable, ReentrancyGuard {
    address public immutable manager;
    ISenseiStake public immutable stake;
    address public immutable weth;
    uint256 public immutable VAULT_AMOUNT;

    uint256 public stakeId;
    bool public locked;

    struct Investor {
        address user;
        uint256 investment;
    }

    event FundsAdded(address indexed investor, uint256 amount, uint256 timestamp);
    event FundsRetired(address indexed investor, uint256 amount, uint256 timestamp);

    constructor(
        ISenseiStake _stake,
        uint256 _VAULT_AMOUNT,
        address _weth
    ) ERC20("StakeToguetherToken", "STT") {
        require(_VAULT_AMOUNT > 0, "Invalid VAULT_AMOUNT");
        VAULT_AMOUNT = _VAULT_AMOUNT;
        manager = msg.sender;
        weth = _weth;
        stake = _stake;
    }

    function initialize() external payable initializer {}

    function addFunds() external payable {
        _addFunds(msg.sender);
    }

    function addFunds(address _investor) external payable {
        require(msg.sender == manager, "permision denied");
        require(_investor != address(0), "invalid address");
        _addFunds(_investor);
    }

    function _addFunds(address _investor) private {
        require(msg.value > 0, "invalid investment");
        require(!locked, "vault locked");

        uint256 fundsToReceive = Math.min(VAULT_AMOUNT - totalSupply(), msg.value);
        require(fundsToReceive > 0, "invalid funds");

        _mint(_investor, fundsToReceive);

        if (fundsToReceive < msg.value) {
            Address.sendValue(payable(_investor), msg.value - fundsToReceive);
            locked = true;
            stakeId = stake.buyNode{value: VAULT_AMOUNT}();
        }

        emit FundsAdded(_investor, fundsToReceive, block.timestamp);
    }

    function retireFunds(uint256 _amount) external payable {
        _retireFunds(msg.sender, _amount);
    }

    function retireFunds(address _investor, uint256 _amount) external payable {
        require(msg.sender == manager, "permision denied");
        require(_investor != address(0), "invalid address");
        _retireFunds(_investor, _amount);
    }

    function _retireFunds(address _investor, uint256 _amount) private nonReentrant {
        require(balanceOf(_investor) > _amount, "invalid amount");
        require(!locked, "vault locked");

        Address.sendValue(payable(_investor), _amount);

        _burn(_investor, _amount);

        emit FundsRetired(_investor, _amount, block.timestamp);
    }

    function exitStake(uint256 _tokenId) external {
        stake.exitStake(_tokenId);

        
    }
}
