// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "./salesannouncement.sol";
import "hardhat/console.sol";

contract Auction{

    SalesAnnouncement sales = new SalesAnnouncement();
    uint public reward; // palkkio %
    mapping(uint => SalesAnnouncement) public announcements; // ilmoituksien osoite
    address payable private owner; // huutokaupan omistaja
    uint index = 0;
        


    constructor(){
        reward = 5; // alustetaan välityspalkkio 5%:iin
        owner = payable(msg.sender);
    }

    receive()external payable{

    }

    fallback()external payable{

    }

    event newSalesAd(address who);
    event rewardChange(uint reward);

    
    modifier OnlyOwner(){
        require(msg.sender == owner,"Decline, you are not the owner");
        _;
    }

    function exchangeCommission(uint _reward)OnlyOwner public{ // vaihdetaan välityspalkkio
        reward = _reward;
        emit rewardChange(_reward);
    }


    function getBalance()OnlyOwner public view returns(uint){
        return address(this).balance;

    }


    function createAnotice(string memory _title, string memory _description, uint _startprice,uint _endtime )public{

        sales.newNotification(owner,payable(msg.sender),_title,_description,_startprice,_endtime,reward);
        announcements[index] = sales;
        emit newSalesAd(msg.sender);
        index++;


    }
    function makeAshout (address _newoffer, uint amount) public {
        sales.setYell(_newoffer, amount);

    }




}