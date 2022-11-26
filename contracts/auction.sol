// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;
/* IMPORTS! */
import "./salesannouncement.sol";

contract Auction {
    mapping(uint256 => SalesAnnouncement) private announcements; // ilmoituksien osoite
    address payable private owner; // huutokaupan omistaja
    address payable private addr; // huutokaupan osoite
    uint256 private reward; // palkkio %
    uint256 index = 0;


    // eventit
    event newSalesAd(address who, address addr);
    event rewardChange(uint256 newReward);

    constructor(){
        owner = payable(msg.sender);
        addr = payable(address(this));
        reward = 5; // alustetaan välityspalkkio 5%:iin
    }

    receive() external payable{
        // tässä tapauksessa ei vaadittu logiikkaa
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
    function makeAshout(uint256 _index) payable public{
        require(index > 0 && _index <= (index - 1),"There is no sale announcement");
        SalesAnnouncement sales = announcements[_index];
        sales.Yell{value:msg.value}(payable(msg.sender));
    }

    // vaihdetaan välityspalkkio
    function exchangeCommission(uint256 _reward) OnlyOwner public returns(bool) {
        require(_reward <= 25,"The maximum amount of the reward is 25%");
        reward = _reward;
        emit rewardChange(_reward);
        return true;
    }

    // nostetaan ethereum sopimukselta pois
    function raiseETH() OnlyOwner public returns(bool) {
        require(getBalance() > 0,"The contract has no ethereum");
        owner.transfer(getBalance());
        return true;
    }

    function getBalance() OnlyOwner public view returns(uint){
        return address(this).balance;
    }

    // haetaan indeksillä myynti-ilmoituksien osoite
    function getAnnouncement(uint256 _index) public view returns(address){
        SalesAnnouncement sales = announcements[_index];
        return address(sales);
    }

    // viimeistellään huutokauppa
    function completeAuction(address isOwner,uint _index) public{
        SalesAnnouncement sales = announcements[_index];
        sales.checkOwner(isOwner);
    }
}

