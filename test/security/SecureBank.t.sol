// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../src/secure/SecureBank.sol";

contract SecureBankAttacker {
    SecureBank public bank;

    constructor(SecureBank _bank) {
        bank = _bank;
    }

    function attack() external payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    receive() external payable {
        // Attempt reentrancy, but do not propagate its failure.
        (bool success,) = address(bank).call(abi.encodeWithSignature("withdraw()"));
        success;
    }
}

contract SecureBankTest is Test {
    SecureBank bank;
    SecureBankAttacker attacker;

    function setUp() public {
        bank = new SecureBank();
        attacker = new SecureBankAttacker(bank);

        vm.deal(address(this), 6 ether);
        bank.deposit{value: 5 ether}();
    }

    function test_ReentrancyCannotDrainVictimFunds() public {
        attacker.attack{value: 1 ether}();

        assertEq(address(bank).balance, 5 ether);
        assertEq(address(attacker).balance, 1 ether);
        assertEq(bank.balances(address(attacker)), 0);
    }

    receive() external payable {}
}
