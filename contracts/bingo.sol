// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Bingo {
    address public host;
    bool public enabled;
    uint256 public ticketPrice;

    struct Ticket {
        uint8[27] numbers; // ticket is 3 rows of 9 numbers = 27 numbers
    }

    mapping(address => Ticket[]) tickets;

    event NewTicket(address player, uint8[27] numbers);

    constructor(uint256 ticketPriceWei) {
        host = msg.sender;
        enabled = true;
        ticketPrice = ticketPriceWei;
    }

    function switchOnOff() public {
        require(msg.sender == host, "Caller is not host");
        enabled = enabled ? false : true;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTickets(address player) public view returns (Ticket[] memory) {
        return tickets[player];
    }

    function buyTicket(uint8[27] memory numbers) payable public {
        require(enabled, "Game is disabled");
        require(msg.value >= ticketPrice, "Insufficient payment");

        tickets[msg.sender].push(Ticket(numbers));

        // refund overpayment
        uint256 refund = msg.value - ticketPrice;
        (bool success, ) = msg.sender.call{value: refund}("");
        require(success, "Refund failed");
       
        // host can watch for this event to be informed of new tickets purchased
        emit NewTicket(msg.sender, numbers);
    }

    function payout(address player, uint256 amountWei) public {
        require(msg.sender == host, "Caller is not host");
        (bool success, ) = player.call{value: amountWei}("");
        require(success, "Payout failed");
    }

    function withdrawBalance() public {
        require(msg.sender == host, "Caller is not host");
        (bool success, ) = host.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }
}
