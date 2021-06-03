// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Bingo {

    address public host;
    uint256 public ticketPrice;
    mapping(address => int8[][]) public players;

    error InsufficientPayment(uint256 ticketPrice, uint256 paid);
    event Purchased(address player,  int8[][] numbers);

    constructor(uint256 _ticketPriceWei) {
        host = msg.sender;
        ticketPrice = _ticketPriceWei;
    }

    function buyTicket(int8[][] memory numbers) public payable {
        if (msg.value < ticketPrice)
            revert InsufficientPayment({ticketPrice: ticketPrice, paid: msg.value});
        players[msg.sender] = numbers;
        emit Purchased(msg.sender, numbers);
    }

}