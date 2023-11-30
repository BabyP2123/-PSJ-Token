// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PSJ is ERC20 {
     using SafeMath for uint256;

address public owner;
uint256 public cap;
mapping(address => uint256) public timeLock;

// Constructor: Set the token name, symbol,owner and cap during deployment
constructor() ERC20("PSJ Token","PSJ") {
    owner = msg.sender;
    cap = 1000000000000000000000000; // 1,000 tokens with 18 decimals
}
    // Mint function with time-lock feature 
    function mint(address to, uint256 amount, uint256 lockDuration) external {
        require(msg.sender == owner, "Not authorized");
        require(totalSupply().add(amount) <= cap, "Exceeds cap");

        _mint(to, amount);
        
        // Apply time-lock if specified 
        if (lockDuration > 0) {
            timeLock[to] = block.timestamp.add(lockDuration);
        }
    }

    // Transferfunction with time-lock check
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(block.timestamp >= timeLock[msg.sender], "Tokens are time-locked");
        return super.transfer(to, amount);
    }
}
