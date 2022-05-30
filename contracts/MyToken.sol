// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <= 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

    address public manager;

    constructor() ERC20('Jagtap Coin', 'JAGGU') { 
         manager = msg.sender;   
        _mint(manager, 100000000 * 10 ** 18);
    } 
}

