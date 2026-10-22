# EtherShield
## Ethereum Smart Contract Security & Exploitation Lab

### 1. Project Objective
EtherShield is an educational project for studying Ethereum smart
contract security in a local testing environment.

### 2. Vulnerability Studied
The project studies reentrancy in a bank contract.
The vulnerable implementation sends ETH before updating the
user's stored balance.

### 3. Vulnerable Implementation
File: src/vulnerable/VulnerableBank.sol

The withdrawal function performs an external call before setting
the user's balance to zero. A malicious receiver can re-enter
the withdrawal function before the balance is updated.

### 4. Exploit Demonstration
Test: test/exploits/Reentrancy.t.sol

The local Foundry test demonstrates that the vulnerable contract
can lose the victim's deposited ETH in the simulated scenario.

### 5. Security Fix
File: src/secure/SecureBank.sol

The fixed implementation sets the user's balance to zero before
making the external ETH transfer. This follows the
Checks-Effects-Interactions pattern.

### 6. Regression Test
Test: test/security/SecureBank.t.sol

The test verifies that the simulated reentrancy attempt does not
drain the victim's funds from the secure implementation.

### 7. Testing
Run the full test suite with:

    forge test -vv

Record the actual test results here before submission.

### 8. Static Analysis
Run:

    slither src/vulnerable/VulnerableBank.sol
    slither src/secure/SecureBank.sol

Record the actual findings for both contracts here.
Static analysis can produce false positives and does not prove
that a contract is completely secure.

### 9. Limitations
This is a local educational demonstration using simulated ETH.
It is not a production-ready banking contract and has not been
audited for all possible vulnerabilities.

### 10. Conclusion
EtherShield demonstrates how a reentrancy issue can be reproduced
with Foundry tests, how the Checks-Effects-Interactions pattern
can mitigate it, and how static analysis can support a security
review.
