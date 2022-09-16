// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ISenseiStake} from "./ISenseiStake.sol";

import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import {WETH} from "../src/mocks/WETH.sol";
import "forge-std/console2.sol";

contract Vault is ERC4626, Initializable, IERC721Receiver {
    ISenseiStake public immutable stake;

    uint256 public immutable VAULT_AMOUNT;

    uint256 public stakeId;

    CurrentState public state;
    enum CurrentState {
        FUNDING,
        WORKING,
        FINISHED
    }

    constructor(
        ISenseiStake _stake,
        uint256 _VAULT_AMOUNT,
        address _weth
    ) ERC4626(ERC20(_weth), "StakeTogetherToken", "STT") {
        require(_VAULT_AMOUNT > 0, "Invalid VAULT_AMOUNT");

        VAULT_AMOUNT = _VAULT_AMOUNT;

        stake = _stake;
    }

    function initialize() external initializer {}

    function maxDeposit() public view returns (uint256) {
        return VAULT_AMOUNT;
    }

    function maxMint(address) public view override returns (uint256) {
        return VAULT_AMOUNT;
    }

    function beforeWithdraw(uint256, uint256) internal view override {
        require(state != CurrentState.WORKING, "node working, funds lock");
    }

    function totalAssets() public view override returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function afterDeposit(uint256, uint256) internal override {
        require(state == CurrentState.FUNDING, "cant deposit");

        // Lock contract if VAULT_AMOUNT is reached
        if (totalAssets() == VAULT_AMOUNT) {
            state = CurrentState.WORKING;
            WETH(payable(address(asset))).withdraw(VAULT_AMOUNT);
            stakeId = stake.buyNode{value: VAULT_AMOUNT}();
        }
    }

    function beforeWithdraw(
        address,
        address,
        address,
        uint256,
        uint256
    ) internal view {
        require(state == CurrentState.FUNDING || state == CurrentState.FINISHED, "vault locked");
    }

    function exitStake(uint256 _tokenId) external {
        stake.exitStake(_tokenId);
    }

    receive() external payable {
        // allow unwrap WETH
        if (address(asset) == msg.sender) {
            return;
        } else if (address(stake) == msg.sender) {
            // wrap eth
            require(state == CurrentState.FINISHED, "node has not finished");
            (bool sent, ) = address(asset).call{value: address(this).balance}("");
            require(sent, "send failed");
        } else {
            revert("no me mandes eth");
        }
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
