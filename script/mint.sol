// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface Endgame {
    function mint() external payable returns (uint256);
}

contract Mint is Script {
    function run() external {
        vm.startBroadcast();
        Endgame e = Endgame(address(0x671633150a3C0fBCb37CAfb8efE514DdE6304f16));

        for (uint256 i = 0; i < 50; i++) {
            e.mint();
        }
    }
}
