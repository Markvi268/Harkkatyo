// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "./salesannouncement.sol";
import "hardhat/console.sol";
contract Auction{
    uint public reward; // palkkio
    mapping(address => uint) public announcements; // ilmoitukset
    address private owner; // huutokaupan omistaja


    constructor(){
        reward = 5; // alustetaan välityspalkkio 5%:iin
        owner = msg.sender;
    }
    modifier OnlyOwner(){
        require(msg.sender == owner,"Decline, you are not the owner");
        _;
    }

    function exchangeCommission(uint _reward)OnlyOwner public{ // vaihdetaan välityspalkkio
        reward = _reward;
    }


}