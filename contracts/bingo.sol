// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Bingo {
    address public host;
    bool public enabled;
    uint256 public ticketPrice;
    
    address[] private players;
    uint256 public ticketCount;

    struct Ticket {
        uint8[27] numbers; // ticket is 3 rows of 9 numbers = 27 numbers
        uint256 paid;
    }

    mapping(address => Ticket[]) tickets;

    event NewTicket(address player, uint8[27] numbers);

    constructor(uint256 _ticketPriceWei) {
        host = msg.sender;
        enabled = true;
        ticketPrice = _ticketPriceWei;
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

    function cancelGame() public {
      require(msg.sender == host, "Caller is not host");
      
      for (uint i=0; i<players.length; i++) {
        address _player = players[i];
        Ticket[] _tickets = tickets[player];
        
        uint refund = 0;
        for (uint i=0; i<_tickets.length; i++) {
          refund += _tickets[i].paid;
        }
   
        (bool success, ) = address.call{value: refund}("");
        if (success) {
          delete tickets[player];
          delete players[i];
          tickerCount -= _tickets.length;
        }
      }
      
      enabled = false;
    }

    function buyTickets(uint8[] memory _numbers) payable public {
        require(enabled, "Game is disabled");
        require(msg.value >= ticketPrice, "Insufficient payment");
        require(_numbers.length % 27 == 0, "Invalid ticket length");
        
        if (tickets[msg.sender].length == 0)
          players.append(msg.sender);
        
        for (uint i=0; i=_numbers.length%27; i++) {
          uint8[27] _ticket = _numbers[i:i*27+27];
          tickets[msg.sender].push(Ticket(_ticket, ticketPrice));
          ticketCount+=1;
        }

        // refund overpayment
        uint256 refund = msg.value - ticketPrice;
        (bool success, ) = msg.sender.call{value: refund}("");
        require(success, "Refund failed");
       
        // host can watch for this event to be informed of new tickets purchased
        emit NewTicket(msg.sender, _numbers);
    }

    function payout(address _player, uint256 _amountWei) public {
        require(msg.sender == host, "Caller is not host");
        require(address(this).balance >= _amountWei, "Not enough balance");
        
        (bool success, ) = _player.call{value: _amountWei}("");
        require(success, "Payout failed");
    }

    function withdrawBalance() public {
        require(msg.sender == host, "Caller is not host");
        
        (bool success, ) = host.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }
}
