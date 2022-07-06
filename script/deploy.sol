// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {EndGame} from "../src/EndGame.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        EndGame add = new EndGame(address(0xBDC105c068715D57860702Da9fa0c5EAd11fbA51));
    }
}
