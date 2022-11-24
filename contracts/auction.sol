// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "./salesannouncement.sol";
import "hardhat/console.sol";

contract Auction {
    mapping(uint256 => SalesAnnouncement) private announcements; // ilmoituksien osoite
    address payable private owner; // huutokaupan omistaja
    address private addr; // huutokaupan osoite
    uint256 private reward; // palkkio %
    uint256 index = 0;


    // eventit
    event newSalesAd(address who, address addr);
    event rewardChange(uint256 newReward);

    constructor(){
        owner = payable(msg.sender);
        addr = address(this);
        reward = 5; // alustetaan välityspalkkio 5%:iin
    }

    receive() external payable{
        // nothing yet
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Decline, you are not the owner");
        _;
    }

    // luodaan uusi myynti-ilmoitus
    function createAnotice(string memory _title,string memory _description,uint256 _startprice,uint256 _endtime)public{

        SalesAnnouncement sales = new SalesAnnouncement(payable(addr),payable(msg.sender),_title,_description,_startprice,_endtime,reward);
         announcements[index] = sales;
        index++;
        emit newSalesAd(msg.sender,address(sales));

    }

    // tehdään tarjous tuotteesta
    function makeAshout(uint256 _index) public payable{
        SalesAnnouncement sales = announcements[_index];
        payable(address(sales)).transfer(address(this).balance); // en saanu muuten toimimaan kun näin. lähetetään rahat myynti-ilmoitukseen, toimii panttina
        sales.Yell(payable(msg.sender),msg.value);
    }

    // vaihdetaan välityspalkkio
    function exchangeCommission(uint256 _reward) public OnlyOwner {
        reward = _reward;
        emit rewardChange(_reward);
    }

    // nostetaan ethereum sopimukselta pois
    function raiseETH(uint amount) OnlyOwner public view returns(bool) {
        require(amount > owner.balance,"Not enought ETH in your account");
        return true;
    }

    // haetaan indeksillä myynti-ilmoituksien osoite
    function getAnnouncement(uint256 _index) public view returns(uint){
        SalesAnnouncement sales = announcements[_index];
        return sales.getBalance();
    }
}

