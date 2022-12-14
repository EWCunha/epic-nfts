// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant totalSupply = 50;

    string baseSvg =
        "<svg  xmlns='http://www.w3.org/2000/svg'  preserveAspectRatio='xMinYMin meet'  viewBox='0 0 350 350'>  <defs>    <linearGradient id='Gradient1'>      <stop class='stop1' offset='0%'/>      <stop class='stop2' offset='50%'/>      <stop class='stop3' offset='100%'/>    </linearGradient>  </defs>  <style>    .base {      fill: blue;      font-family: serif;      font-size: 20px;      color: #FFF;    }    .stop1 { stop-color: green; }    .stop2 { stop-color: white; stop-opacity: 0; }    .stop3 { stop-color: yellow; }      </style>  <rect width='100%' height='100%' fill='url(#Gradient1)' />  <text    x='50%'    y='50%'    class='base'    dominant-baseline='middle'    text-anchor='middle'  >";

    string[] firstWords = [
        "Hamburger",
        "Batata",
        "Pudim",
        "Chocolate",
        "Cheesecake",
        "Sorvete"
    ];
    string[] secondWords = [
        "Kung-fu",
        "Kenjutsu",
        "Taekwondo",
        "Jiujitsu",
        "Karate",
        "Judo"
    ];
    string[] thirdWords = [
        "Brasil",
        "Alemanha",
        "Franca",
        "Englaterra",
        "Canada",
        "Grecia"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("ChavesNFT", "CHAVO") {
        console.log("Meu contrato de NFT! Tchu-hu");
    }

    function getTotalNFTsMintedSoFar()
        external
        view
        returns (Counters.Counter memory)
    {
        return _tokenIds;
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = _random(
            string(
                abi.encodePacked("PRIMEIRA_PALAVRA", Strings.toString(tokenId))
            )
        );

        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = _random(
            string(
                abi.encodePacked("SEGUNDA_PALAVRA", Strings.toString(tokenId))
            )
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = _random(
            string(
                abi.encodePacked("TERCEIRA_PALAVRA", Strings.toString(tokenId))
            )
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function _random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        require(_tokenIds.current() < totalSupply, "No more supply");
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "Uma colecao aclamada e famosa de NFTs maravilhosos.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "Um NFT com o ID %s foi mintado para %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
