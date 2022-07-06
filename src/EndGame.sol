pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Renderer} from "./Renderer.sol";
import {Base64} from "./Base64.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {Strings} from "./Strings.sol";

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

interface IERC2981 {
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

error NOT_AUTHORIZED();

contract EndGame is ERC721, Renderer, IERC2981, Owned {
    using Base64 for bytes;
    using Strings for uint256;

    struct seed {
        uint256 number;
    }

    IERC721 public detris;
    uint256 private entropy;
    uint256 public currentTokenId;
    mapping(uint256 => seed) public idToSeed;

    constructor(address _detris) ERC721("DetrisEndGame", "DEG") Owned(msg.sender) {
        detris = IERC721(_detris);
    }

    function mint() public payable returns (uint256) {
        if (!isDetrisHolder(msg.sender)) {
            revert NOT_AUTHORIZED();
        }

        uint256 newItemId = ++currentTokenId;
        _safeMint(msg.sender, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        string memory idString = id.toString();
        string memory svgEncoded = bytes(render(id)).encode();
        string memory base64SVG = string.concat("data:image/svg+xml;base64,", svgEncoded);

        string memory metadata = bytes(
            string.concat(
                '{ "name": "End Game ',
                idString,
                '",',
                '"description": "End Game ',
                idString,
                '",',
                '"image": "',
                base64SVG,
                '"}'
            )
        ).encode();

        string memory base64Metadata = string.concat("data:application/json;base64,", metadata);

        return base64Metadata;
    }

    // IERC2981
    function royaltyInfo(uint256, uint256 _salePrice) external view override returns (address, uint256) {
        return (owner, (_salePrice * 15) / 100);
    }

    function isDetrisHolder(address possibleOwner) public view returns (bool) {
        return detris.balanceOf(possibleOwner) > 0;
    }
}
