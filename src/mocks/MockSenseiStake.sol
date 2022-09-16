
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, Ownable {
    mapping(uint256 => uint256) public exitDate;

    uint256 private _tokenIdCounter;

    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to) internal {
        uint256 tokenId = _tokenIdCounter;
        unchecked {
            ++_tokenIdCounter;
        }
        // around 6 months
        exitDate[tokenId] = block.timestamp + 30 days * 6;
        _safeMint(to, tokenId);
    }

    function buyNode() external payable {
        require(msg.value == 32 ether, "need 32 ether");
        safeMint(msg.sender);   
    }

    function exitStake(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "!owner of vault");
        require(exitDate[tokenId] > block.timestamp, "cant exit yet");
        _burn(tokenId);
        payable(msg.sender).call{value: 33 ether}();
    }
}