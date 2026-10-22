// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be positive");
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        // Fix: update state before sending ETH.
        balances[msg.sender] = 0;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
