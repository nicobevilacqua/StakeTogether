// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MockSenseiStake is ERC721, Ownable {
    mapping(uint256 => uint256) public exitDate;

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
        _safeMint(msg.sender, tokenId);

        return tokenId;
    }

    function exitStake(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "!owner of vault");
        require(exitDate[tokenId] > block.timestamp, "cant exit yet");
        _burn(tokenId);
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(sent, "invalid");
    }
}
