# EtherShield
## Ethereum Smart Contract Security & Exploitation Lab

## 1. Project Objective
EtherShield is an educational lab for studying Ethereum smart
contract security using Solidity, Foundry and Slither.

## 2. Project Structure
- `src/vulnerable/VulnerableBank.sol`: intentionally vulnerable bank
- `src/secure/SecureBank.sol`: bank with a reentrancy mitigation
- `test/exploits/Reentrancy.t.sol`: local exploit demonstration
- `test/security/SecureBank.t.sol`: security regression test
- `README.md`: project setup and commands

## 3. Vulnerability: Reentrancy
In the vulnerable contract, `withdraw()` sends ETH to the caller
before setting the caller's balance to zero.

A malicious receiver can call `withdraw()` again during the
external call, before the original balance update is completed.

## 4. Exploit Demonstration
The Foundry test `test_ReentrancyDrainsVictimFunds()` passed.

In the simulated scenario, the bank starts with 5 ETH deposited
by the victim. The attacker deposits 1 ETH and exploits the
withdrawal logic to receive 6 ETH in total.

This demonstration uses simulated ETH in a local test environment.

## 5. Mitigation
The secure contract sets `balances[msg.sender]` to zero before
making the external ETH transfer.

This follows the Checks-Effects-Interactions pattern and prevents
the demonstrated reentrancy scenario.

## 6. Test Results
The full Foundry test run reported:
- 4 tests passed
- 0 tests failed
- 0 tests skipped

The test suites include the vulnerable contract exploit test,
the secure contract regression test, and the default Counter tests.

## 7. Slither Static Analysis
Analysis of `VulnerableBank.sol` reported 3 findings:
- `reentrancy-eth`: the external ETH call occurs before the
  balance is updated.
- `solc-version`: the pragma `^0.8.20` allows compiler versions
  that Slither flags for known compiler issues.
- `low-level-calls`: the contract uses a low-level ETH call.

Analysis of `SecureBank.sol` reported 2 findings:
- `solc-version`: the same pragma constraint warning.
- `low-level-calls`: the ETH transfer uses a low-level call.

Slither did not report the reentrancy detector for the secure
contract in this analysis. This does not prove complete security.
The low-level-call finding requires context-based review, and the
compiler-version warning should be addressed separately.

## 8. Limitations
This is a small educational demonstration, not a production-ready
banking contract or a complete security audit.

Only the demonstrated reentrancy scenario has been tested.
Additional tests and review are needed before real deployment.

## 9. Conclusion
EtherShield demonstrates a reentrancy vulnerability, reproduces
it in Foundry, applies a state-update mitigation, and compares
static-analysis results for vulnerable and secure implementations.
