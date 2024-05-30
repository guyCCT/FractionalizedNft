// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721Burnable, Ownable {
    uint256 public tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mint(address to) public onlyOwner {
        _mint(to, tokenIdCounter);
        tokenIdCounter++;
    }
}
