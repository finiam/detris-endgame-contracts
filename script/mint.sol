// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface Endgame {
    function mint() external payable returns (uint256);
}

contract Mint is Script {
    function run() external {
        vm.startBroadcast();
        Endgame e = Endgame(address(0xA8370425458dbf823c7d4BA777E6A091791c2528));

        for (uint256 i = 0; i < 50; i++) {
            e.mint();
        }
    }
}
