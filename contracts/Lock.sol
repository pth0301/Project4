// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Lock {
    uint public unlockTime; // timestamp when ETH can be withdrawn
    address payable public owner; // address of owner can receive ETH

    event Withdrawal(uint amount, uint when); // logs the withdrawal amount and time for transparency

    constructor(uint _unlockTime) payable { // execute only once when a smart contract ís deployed
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender); // allow sending ETH during delpoyment
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp); // lấy số dư ETH của contract: address(this).balance

        owner.transfer(address(this).balance);// send all ETH in the contract to the owner
    }
}
/** Timelock wallet. It:
 * Accepts ETH during deployment
 * Locks the ETH until a future unlock time
 * Allows the contract deployer (owner) to withdraw the ETH only after that time
 * -> Time-based restrictions + security&trust(ensure the sender + recipient agree on conditions before funds are accessible)
 */