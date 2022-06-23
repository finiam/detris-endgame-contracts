// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {XConsole} from "./XConsole.sol";

import {Test, Vm} from "forge-std/Test.sol";

contract DSTestPlus is Test {
    address constant bob = address(0xB0B);
    address constant alice = address(0xBAD);
    address constant eve = address(0xE5E);

    XConsole console = new XConsole();
}
