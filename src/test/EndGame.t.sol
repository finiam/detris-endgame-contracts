// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import {EndGame} from "../EndGame.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

import {DSTestPlus} from "./utils/DSTestPlus.sol";

contract DetrisMock is ERC721 {
    uint256 public currentTokenId;

    constructor() ERC721("Detris", "DTRS") {}

    function tokenURI(uint256) public view virtual override returns (string memory) {
        return "";
    }

    function mint() public virtual {
        uint256 newItemId = ++currentTokenId;
        _safeMint(msg.sender, newItemId);
    }
}

contract EndGameTest is DSTestPlus {
    DetrisMock public detris;
    EndGame public endGame;

    function setUp() public {
        detris = new DetrisMock();
        endGame = new EndGame(address(detris));
    }

    function testMint() public {
        vm.startPrank(bob);
        detris.mint();
        endGame.mint();
        vm.stopPrank();

        assertEq(endGame.balanceOf(bob), 1);
        assertEq(endGame.ownerOf(1), bob);
    }

    function testCannotMintWithoutDetris() public {
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSignature("NOT_AUTHORIZED()"));
        endGame.mint();
        vm.stopPrank();
    }

    //    function testRender() public {
    //        endGame.tokenURI(1);
    //    }
}
