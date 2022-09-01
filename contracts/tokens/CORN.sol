// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CORN is ERC20 {
    constructor() ERC20("$CORN", "$CORN") {
        _mint(msg.sender, 1000000e18);
    }
}