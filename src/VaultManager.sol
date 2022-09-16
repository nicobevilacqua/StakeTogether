// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ISenseiStake} from "./ISenseiStake.sol";
import "forge-std/console2.sol";

contract VaultManager {
    uint256 public constant VAULT_AMOUNT = 32 ether;
    address public immutable vaultImplementation;
    address public weth;

    Vault internal _nextVault;

    mapping(address => address[]) public userVaults;

    address[] public vaults;

    event FundsAdded(address indexed user, uint256 amount, uint256 timestamp);
    event VaultCreated(address indexed vault, uint256 timestamp);

    constructor(ISenseiStake _stake, address _weth) {
        weth = _weth;
        vaultImplementation = address(new Vault(_stake, VAULT_AMOUNT, _weth));
        _createNextVault();
    }

    function depositToVault(uint256 _amount) public {
        require(_amount > 0, "insufficient funds");

        uint256 vaultTotalAssets = _nextVault.totalAssets();

        uint256 assetsToDeposit = Math.min(VAULT_AMOUNT - vaultTotalAssets, _amount);

        SafeERC20.safeTransferFrom(IERC20(weth), msg.sender, address(this), assetsToDeposit);

        IERC20(weth).approve(address(_nextVault), assetsToDeposit);

        _nextVault.deposit(assetsToDeposit, msg.sender);

        userVaults[msg.sender].push(address(_nextVault));

        if (_nextVault.totalAssets() == VAULT_AMOUNT) {
            _createNextVault();
        }

        emit FundsAdded(msg.sender, assetsToDeposit, block.timestamp);
    }

    function _createNextVault() private {
        address _nextVaultAddress = Clones.clone(vaultImplementation);
        _nextVault = Vault(payable(_nextVaultAddress));

        Vault(_nextVault).initialize();

        vaults.push(_nextVaultAddress);

        emit VaultCreated(_nextVaultAddress, block.timestamp);
    }

    function getUserVaults() public view returns (address[] memory) {
        return userVaults[msg.sender];
    }
}
