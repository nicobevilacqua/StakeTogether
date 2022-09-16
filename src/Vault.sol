// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {WETH} from "solmate/tokens/WETH.sol";

import {ISenseiStake} from "./ISenseiStake.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Vault is ERC4626, Initializable, IERC721Receiver {
    ISenseiStake public immutable stake;

    uint256 public immutable VAULT_AMOUNT;

    uint256 public tokenId;

    CurrentState public state;
    enum CurrentState {
        FUNDING,
        WORKING,
        FINISHED
    }

    constructor(
        address _stake,
        uint256 _VAULT_AMOUNT,
        address _weth
    ) ERC4626(ERC20(_weth), "StakeTogetherToken", "STT") {
        require(_VAULT_AMOUNT > 0, "Invalid VAULT_AMOUNT");

        VAULT_AMOUNT = _VAULT_AMOUNT;

        stake = ISenseiStake(_stake);
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
            tokenId = stake.buyNode{value: VAULT_AMOUNT}();
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

    function exitStake() external {
        state = CurrentState.FINISHED;
        stake.exitStake(tokenId);
        (bool sent, ) = address(asset).call{value: address(this).balance}("");
        require(sent, "send failed");
    }

    receive() external payable {}

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
