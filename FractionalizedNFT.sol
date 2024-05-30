// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./FractionalToken.sol";

contract FractionalizedNFT is Ownable {
    IERC721 public nftContract;
    mapping(uint256 => address) public fractionalTokens;

    event NFTFractionalized(uint256 indexed tokenId, address fractionalToken);
    event FractionBurned(uint256 indexed tokenId, address indexed burner, uint256 amount);

    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    function fractionalize(uint256 tokenId, uint256 totalSupply, string memory name, string memory symbol) public onlyOwner {
        require(nftContract.ownerOf(tokenId) == address(this), "Contract does not own the NFT");
        require(fractionalTokens[tokenId] == address(0), "NFT already fractionalized");

        FractionalToken fractionalToken = new FractionalToken(name, symbol, totalSupply);
        fractionalTokens[tokenId] = address(fractionalToken);

        emit NFTFractionalized(tokenId, address(fractionalToken));
    }

    function mintAndFractionalize(address to, uint256 tokenId, uint256 totalSupply, string memory name, string memory symbol) public onlyOwner {
        require(nftContract.ownerOf(tokenId) == address(this), "Contract does not own the NFT");
        fractionalize(tokenId, totalSupply, name, symbol);
        IERC20(fractionalTokens[tokenId]).transfer(to, totalSupply);
    }

    function depositNFT(uint256 tokenId) public {
        nftContract.transferFrom(msg.sender, address(this), tokenId);
    }

    function withdrawNFT(uint256 tokenId) public onlyOwner {
        require(fractionalTokens[tokenId] == address(0), "NFT is fractionalized");
        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }

    function burnFraction(uint256 tokenId, uint256 amount) public {
        require(fractionalTokens[tokenId] != address(0), "NFT is not fractionalized");
        FractionalToken fractionalToken = FractionalToken(fractionalTokens[tokenId]);
        require(fractionalToken.balanceOf(msg.sender) >= amount, "Insufficient token balance");
        fractionalToken.burn(amount);
        emit FractionBurned(tokenId, msg.sender, amount);
    }
}
