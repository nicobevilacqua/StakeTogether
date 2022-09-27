// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {ISenseiStake} from "./ISenseiStake.sol";

/**
 * @title VaultManager contract, main platform's contract
 * @dev Main Contract responsible of collect ether from users and create new vaults when needed
 */
contract VaultManager {
    /// @notice The amount if eth needed for every vault
    uint256 public constant VAULT_AMOUNT = 32 ether;

    /// @notice The vault implementation address
    address public immutable vaultImplementation;

    /// @notice The weth contract address
    WETH public immutable weth;

    /// @notice The vault that is being funded currently (until `VAULT_AMOUNT` is reached)
    Vault internal _nextVault;

    /// @notice The list of `Vaults` where `user` has some funds
    mapping(address => address[]) public userVaults;

    /// @notice The list of all `Vaults` created by this contract
    address[] public vaults;

    /**
     * @dev Emitted when `amount` of weth is sent by `user` on `timestamp` to the contract
     */
    event FundsAdded(address indexed user, uint256 amount, uint256 timestamp);

    /**
     * @dev Emitted when `vault` is created on `timestamp`
     */
    event VaultCreated(address indexed vault, uint256 timestamp);

    /// Constructor
    constructor(address _stake, address _weth) {
        weth = WETH(payable(_weth));
        vaultImplementation = address(new Vault(_stake, VAULT_AMOUNT, _weth));
        _createNextVault();
    }

    /**
     * @dev Deposit WETH to the found, create a new vault if VAULT_AMOUNT is reached, mint tokens to the user as a transfer receipt
     * @param _amount - amount of weth to be transfered from `msg.sender` to the contract
     * @notice only the needed weth is deposited
     * @notice weth should be allowed to be transfered to the contract first
     *
     * May create a new vault instance if `VAULT_AMOUNT` is reached.
     *
     * Emits a {FundsAdded} event.
     */
    function depositToVault(uint256 _amount) external {
        require(_amount > 0, "insufficient funds");

        SafeTransferLib.safeTransferFrom(weth, msg.sender, address(this), _amount);

        _depositToVault(_amount);
    }

    /**
     * @dev Deposit ETH to the found, create a new vault if VAULT_AMOUNT is reached, mint tokens to the user as a transfer receipt
     * @notice msg.value will be wrapped into weth
     *
     * May create a new vault instance if `VAULT_AMOUNT` is reached.
     *
     * Emits a {FundsAdded} event.
     */
    function depositToVault() public payable {
        require(msg.value > 0, "insufficient funds");

        weth.deposit{value: msg.value}();

        _depositToVault(msg.value);
    }

    function _depositToVault(uint256 _amount) private {
        uint256 pendingFunds = _amount;

        while (pendingFunds > 0) {
            uint256 vaultTotalAssets = _nextVault.totalAssets();

            /**
             * Get just the required weth to fullfill the current vault
             */
            uint256 assetsToDeposit = Math.min(VAULT_AMOUNT - vaultTotalAssets, pendingFunds);

            _nextVault.deposit(assetsToDeposit, msg.sender);

            if (!_isUserVault(address(_nextVault))) {
                userVaults[msg.sender].push(address(_nextVault));
            }

            if (_nextVault.totalSupply() == VAULT_AMOUNT) {
                _createNextVault();
            }

            pendingFunds -= assetsToDeposit;
        }

        emit FundsAdded(msg.sender, _amount, block.timestamp);
    }

    /**
     * @notice Function that returns if `msg.sender` already has `_vault` in his vaults list
     * @dev Function that returns if `msg.sender` already has `_vault` in his vaults list
     * @param _vault - The vault address
     * @return bool - If `_vault` is already an user's vault
     */
    function _isUserVault(address _vault) private view returns (bool) {
        uint256 userVaultsLength = userVaults[msg.sender].length;
        for (uint256 i = 0; i < userVaultsLength;) {
            if (userVaults[msg.sender][i] == _vault) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

    /**
     * @dev private function that creates a new vault, and approved the weth transfer to that contract
     *
     * Emits a {VaultCreated} event.
     */
    function _createNextVault() private {
        address _nextVaultAddress = Clones.clone(vaultImplementation);
        _nextVault = Vault(payable(_nextVaultAddress));
        Vault(payable(_nextVaultAddress)).initialize();

        vaults.push(_nextVaultAddress);

        weth.approve(address(_nextVaultAddress), type(uint256).max);

        emit VaultCreated(_nextVaultAddress, block.timestamp);
    }

    /**
     * @dev Get `msg.sender` vaults array
     * @return address[]
     */
    function getUserVaults() public view returns (address[] memory) {
        return userVaults[msg.sender];
    }

    /**
     * @dev Get total amount of vaults created
     * @return length
     */
    function getVaultsLen() public view returns (uint256) {
        return vaults.length;
    }

    /**
     * @dev Get current vaults
     * @return length
     */
    function getVaults() public view returns (address[] memory) {
        return vaults;
    }
}
