pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Renderer} from "./Renderer.sol";
import {Base64} from "./Base64.sol";
import {Owned} from "solmate/auth/Owned.sol";

interface IERC2981 is IERC165 {
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

contract EndGame is ERC721, Renderer, IERC2981, Owned {
    using Base64 for bytes;

    uint256 public currentTokenId;
    address public owner
    mapping(uint256 => uint256) public seeds;

    constructor() ERC721("DetrisEndGame", "DEG") {}

    function mint() public payable returns (uint256) {
        uint256 newItemId = ++currentTokenId;
        _safeMint(msg.sender, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        string memory svgEncoded = bytes(render(1)).encode();
        string memory base64 = string.concat("data:image/svg+xml;base64,", svgEncoded);

        return base64;
    }

    // IERC2981
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        override
        returns (address, uint256)
    {
        return (owner, (_salePrice * 15) / 100);
    }
}
