// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {ISenseiStake} from "./ISenseiStake.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/**
 * @title Vault instance
 * @author StakeTogether
 * @dev Contract created every time `vaultAmount` is reached by `VaultManager`
 */
contract Vault is ERC4626, Initializable, IERC721Receiver {
    /**
     * @dev reference to SenseiNode contract
     */
    ISenseiStake public immutable stake;

    /**
     * @dev Max amount of weth to be transfered to the vault
     */
    uint256 public immutable vaultAmount;

    /// @notice Vault's ERC721 tokenId minted after the vault is created on SenseiNode
    uint256 public tokenId;

    /// @notice 
    uint256 public totalEarns;

    /// @notice vault current state
    CurrentState public state;
    
    enum CurrentState {
        FUNDING,
        WORKING,
        FINISHED
    }

    constructor(
        address _stake,
        uint256 _vaultAmount,
        address _weth
    ) ERC4626(ERC20(_weth), "StakeTogetherToken", "STT") {
        require(_vaultAmount > 0, "Invalid vaultAmount");

        vaultAmount = _vaultAmount;

        stake = ISenseiStake(_stake);
    }

    receive() external payable {}

    function initialize() external initializer {
    }

    function maxDeposit() public view returns (uint256) {
        return vaultAmount;
    }

    function maxMint(address) public view override returns (uint256) {
        return vaultAmount;
    }

    function beforeWithdraw(uint256, uint256) internal view override {
        require(state != CurrentState.WORKING, "node working, funds lock");
    }

    function totalAssets() public view override returns (uint256) {
        return asset.balanceOf(address(this));
    }

    /// @notice Deposits can be done only if the max amount has not being reached yet
    /// @dev Deposits can be done only if the max amount has not being reached yet
    function afterDeposit(uint256, uint256) internal override {
        require(state == CurrentState.FUNDING, "cant deposit");

        // Lock contract if vaultAmount is reached
        if (totalAssets() == vaultAmount) {
            state = CurrentState.WORKING;
            WETH(payable(address(asset))).withdraw(vaultAmount);
            tokenId = stake.buyNode{value: vaultAmount}();
        }
    }

    /// @notice Get eth burning tokens
    /// @notice Get eth burning tokens
    function redeemETH(uint256 assets) external {
        WETH _weth = WETH(payable(address(asset)));
        uint256 _earn = previewRedeem(assets);
        redeem(assets, address(this), msg.sender);
        _weth.withdraw(_earn);
        (bool sent, ) = address(msg.sender).call{value: _earn}("");
        require(sent, "send failed");
    }

    /// @notice Eth can be withdrawn only if the vault has been unlocked or the vault has not been created yet
    /// @dev Eth can be withdrawn only if the vault has been unlocked or the vault has not been created yet
    function beforeWithdraw(
        address,
        address,
        address,
        uint256,
        uint256
    ) internal view {
        require(state == CurrentState.FUNDING || state == CurrentState.FINISHED, "vault locked");
    }

    /// @notice Removes the tokens from the node and gets the rewards from SenseiNode
    /// @dev Removes the tokens from the node and gets the rewards from SenseiNode, wraps the eth
    function exitStake() external {
        state = CurrentState.FINISHED;
        stake.exitStake(tokenId);
        totalEarns = address(this).balance;
        (bool sent, ) = address(asset).call{value: address(this).balance}("");
        require(sent, "send failed");
    }

    /// @notice Function called after the vault is created and the ERC721 token is transfered
    /// @dev Function called after the vault is created and the ERC721 token is transfered https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#IERC721Receiver-onERC721Received-address-address-uint256-bytes-
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    /// @notice Returns the vault exit date
    /// @dev Returns the vault exit date
    /// @return exitDate
    function exitDate() external view returns (uint256) {
        return stake.exitDate(tokenId);
    }

    /// @notice Returns if the exit date has been reached and the tokens can be redeemed
    /// @dev Returns if the exit date has been reached and the tokens can be redeemed
    /// @return canExit
    function canExit() external view returns (bool) {
        return stake.exitDate(tokenId) < block.timestamp;
    }
}
