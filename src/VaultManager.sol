// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {ISenseiStake} from "./ISenseiStake.sol";
// import "forge-std/console2.sol";

contract VaultManager {
    uint256 public constant VAULT_AMOUNT = 32 ether;
    address public immutable vaultImplementation;
    address public immutable weth;

    Vault internal _nextVault;

    mapping(address => address[]) public userVaults;

    address[] public vaults;

    event FundsAdded(address indexed user, uint256 amount, uint256 timestamp);
    event VaultCreated(address indexed vault, uint256 timestamp);

    constructor(address _stake, address _weth) {
        weth = _weth;
        vaultImplementation = address(new Vault(_stake, VAULT_AMOUNT, _weth));
        _createNextVault();
    }

    function depositToVault(uint256 _amount) public {
        require(_amount > 0, "insufficient funds");

        uint256 vaultTotalAssets = _nextVault.totalAssets();

        uint256 assetsToDeposit = Math.min(VAULT_AMOUNT - vaultTotalAssets, _amount);

        SafeTransferLib.safeTransferFrom(ERC20(weth), msg.sender, address(this), assetsToDeposit);

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
        Vault(payable(_nextVaultAddress)).initialize();

        vaults.push(_nextVaultAddress);

        ERC20(weth).approve(address(_nextVaultAddress), type(uint256).max);

        emit VaultCreated(_nextVaultAddress, block.timestamp);
    }

    function getUserVaults() public view returns (address[] memory) {
        return userVaults[msg.sender];
    }
}
