// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title SenseiNode's contract interface
 */
interface ISenseiStake is IERC721 {
    function exitDate(uint256 _id) external view returns (uint256);

    function buyNode() external payable returns (uint256);

    function exitStake(uint256 tokenId) external;
}
