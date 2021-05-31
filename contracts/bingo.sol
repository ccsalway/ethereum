// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bingo {

    mapping(address => bool) admins;
    mapping(address => uint[]) players;

    constructor() {
        admins[msg.sender] = true;
    }

    function enableAdmin(address admin) public {
        require(admins[msg.sender] == true);
        admins[admin] = true;
    }

    function disableAdmin(address admin) public {
        require(admins[msg.sender] == true);
        admins[admin] = false;
    }

    function isAdmin(address admin) public view returns (bool) {
        return admins[admin];
    }

}