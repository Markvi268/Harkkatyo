// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "./salesannouncement.sol";
import "hardhat/console.sol";

contract Auction{

    uint private reward; // palkkio %
    mapping(uint => SalesAnnouncement) private announcements; // ilmoituksien osoite
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

    event newSalesAd(address who, address addr);
    event rewardChange(uint reward);

    function money() payable public{
           
    }
    
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

        SalesAnnouncement sales = new SalesAnnouncement(owner,payable(msg.sender),_title,_description,_startprice,_endtime,reward);
        announcements[index] = sales;
        emit newSalesAd(msg.sender,address(sales));
        index++;


    }

    function makeAshout (uint _index) public payable {
        SalesAnnouncement sales = announcements[_index]; // valitaan ilmoitus mitä huudetaan
        require(msg.value >= sales.highestPrice(),"You offer is too low");
        sales.setYell(payable(msg.sender), msg.value);

    }

    function getAnnouncements(uint _index) public view returns(address){
        SalesAnnouncement sales = announcements[_index];
        return address(sales);

    }

    function callFinished(uint _index) public {
        SalesAnnouncement sales = announcements[_index];
        sales.setFinished();
    }




}