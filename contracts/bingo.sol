// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Bingo {
    address public host;
    uint256 public ticketPrice;
    bool public enabled;

    address[] private players;
    uint256 public ticketCount;

    mapping(address => uint8[]) tickets;  // players => numbers[]

    event NewPurchase(address player, uint8[] numbers);

    constructor(uint256 _ticketPriceWei) {
        host = msg.sender;
        ticketPrice = _ticketPriceWei;
        enabled = true;
    }

    modifier onlyHost {
        require(msg.sender == host, "Caller is not host");
        _;
    }

    function toggleEnabled() public onlyHost {
        enabled = enabled ? false : true;
    }

    function getBalance() public onlyHost view returns (uint256) {
        return address(this).balance;
    }

    function getTickets(address player) public onlyHost view returns (uint8[] memory) {
        return tickets[player];
    }

    function buyTickets(uint8[] memory _numbers) public payable {
        require(enabled, "Game is disabled");
        require(_numbers.length % 27 == 0, "Invalid ticket length");

        // check enough funds have been transferred in
        uint256 _ticketCount = _numbers.length % 27;
        uint256 _cost = ticketPrice * _ticketCount;
        require(msg.value >= _cost, "Insufficient payment");

        // add tickets to senders address
        for (uint n = 0; n < _numbers.length; n++)
            tickets[msg.sender].push(_numbers[n]);
        ticketCount += _ticketCount;

        // ensure player is listed
        if (tickets[msg.sender].length == 0) 
            players.push(msg.sender);

        // return any over payment
        (bool success, ) = msg.sender.call{value: msg.value - _cost}("");
        require(success, "Refund failed");

        // host can watch for this event to be informed of new tickets purchased
        emit NewPurchase(msg.sender, _numbers);
    }

    function payout(address _player, uint256 _amountWei) public onlyHost {
        require(address(this).balance >= _amountWei, "Not enough balance");

        (bool success, ) = _player.call{value: _amountWei}("");
        require(success, "Payout failed");
    }

    function withdrawBalance() public onlyHost {
        (bool success, ) = host.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    function cancelGame() public onlyHost {
        for (uint i = players.length - 1; i >= 0; i--) {
            address _player = players[i];
            uint8[] memory _tickets = tickets[_player];

            uint256 _ticketCount = _tickets.length % 27;
            (bool success, ) = _player.call{value: _ticketCount * ticketPrice}("");
            require(success, "Refund failed");

            delete players[i];
            delete tickets[_player];
        }
        ticketCount = 0;
        enabled = false;
    }
}
