// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MockSenseiStake is ERC721, Ownable {
    mapping(uint256 => uint256) public exitDate;
    mapping(uint256 => uint256) public balance;

    uint256 private _tokenIdCounter;

    constructor() ERC721("MyToken", "MTK") {}

    function buyNode() external payable returns (uint256) {
        require(msg.value == 32 ether, "need 32 ether");
        uint256 tokenId = _tokenIdCounter;
        unchecked {
            ++_tokenIdCounter;
        }
        // around 6 months
        exitDate[tokenId] = block.timestamp + 30 days * 6;
        balance[tokenId] += 32 ether;

        _safeMint(msg.sender, tokenId);

        return tokenId;
    }

    function addRewards(uint256 tokenId) external payable {
        balance[tokenId] += msg.value;
    }

    function exitStake(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "!owner of vault");
        require(exitDate[tokenId] <= block.timestamp, "cant exit yet");
        _burn(tokenId);
        uint256 bal = balance[tokenId];
        delete (balance[tokenId]);
        (bool sent, ) = payable(msg.sender).call{value: bal}("");
        require(sent, "invalid transfer to owner");
    }
}
