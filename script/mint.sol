// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface Endgame {
    function mint() external payable returns (uint256);
}

contract Mint is Script {
    function run() external {
        vm.startBroadcast();
        Endgame e = Endgame(address(0x7360E6FC6346b06C1500CF780eC52e7Df1dcB7Ef));

        for (uint256 i = 0; i < 50; i++) {
            e.mint();
        }
    }
}
