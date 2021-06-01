// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
UK 90-ball bingo (9x3 tickets)
numbers are arranged in columns 1-9, 10-19, 20-29, ..., 80-89
each row contains five numbers and four blank spaces
each column contains up to three numbers
each ticket has 15 numbers
each page has 6 tickets
Rewards:
15% 1 line
25% 2 lines
40% 3 lines
20% host

due to the compute used to reset the mapping of players,
launch a new contract for each game
*/

contract Bingo {

    address private host;
    uint256 private ticketPrice;  // wei
    mapping(address => string) private players;  // string holds ticket numbers

    constructor(uint256 _ticketPrice) {
        host = msg.sender;
        ticketPrice = _ticketPrice;
    }

    function getTicketPrice() public view returns (uint256) {
        return ticketPrice;
    }

}