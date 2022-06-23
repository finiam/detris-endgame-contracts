// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import {EndGame} from "../EndGame.sol";

import {DSTestPlus} from "./utils/DSTestPlus.sol";

contract EndGameTest is DSTestPlus {
    EndGame public endGame;

    function setUp() public {
        endGame = new EndGame();
    }

    function testMint() public {
        vm.prank(bob);
        endGame.mint();

        string memory base64 = endGame.tokenURI(1);

        console.log(base64);

        assertEq(endGame.balanceOf(bob), 1);
        assertEq(endGame.ownerOf(1), bob);
    }

    function testRender() public {
        endGame.render(1);
    }
}
