// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {WETH} from "solmate/tokens/WETH.sol";
import {MockSenseiStake} from "../src/mocks/MockSenseiStake.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract DepositScript is Script {
    function run() public {
        vm.startBroadcast();

        MockSenseiStake(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512).addRewards{value: 4 ether}(0);
        MockSenseiStake(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512).addRewards{value: 2 ether}(1);
        MockSenseiStake(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512).addRewards{value: 8 ether}(2);
        MockSenseiStake(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512).addRewards{value: 3 ether}(3);

        vm.stopBroadcast();
    }
}
