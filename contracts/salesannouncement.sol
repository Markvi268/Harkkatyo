// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
//import "./auction.sol";
import "hardhat/console.sol";

contract SalesAnnouncement {
  //  mapping(uint256 => Auction) private announcements; // ilmoituksien osoite
    address payable public owner; // ilmoituksen omistaja
    address payable private addr; // huutokaupan osoite
    address payable bidder;
    address payable[] public previousBidder; // aikaisemmat tarjoajat
    string  public title; // kohteen otsikko
    string  public description; // kohteen kuvaus
    uint256 public endtime; // päättymisaika
    uint256 public deposit; // pantti
    uint256 public price; // pohjahinta
    uint256 public newPrice; // uusihinta
    uint256 public reward; //huutokaupan palkkio
    uint256 public ownerpart; // omistajan osuus
    uint256 index = 0;
    uint256 apuindex = 0;

    event newYell(address who, uint256 howMuch);


    constructor(address payable _addr,address payable _owner,string memory _title,string memory _description,uint256 _startprice,uint256 _endtime, uint _reward) {
        owner = _owner;
        addr = _addr;
        title = _title;
        description = _description;
        price = _startprice;
        endtime = block.number + _endtime;
        reward = _reward;


    }

    receive() external payable {
        Yell(msg.sender,msg.value);
    }

    modifier Onlyowner() {
        require(msg.sender == owner,"You are not the submitter of the sale notice");
        _;
    }

    modifier OnlyBlockTime(){
        require(block.number < endtime,"Auction closed");
        _;
    }

   // huudetaan tuotetta ja palauteutetaan rahat edelliselle omistajalle
    function Yell(address _newBidder, uint256 amount) OnlyBlockTime public payable {
        require(amount > price,"You offer is too low");
        price = amount;
        emit newYell(_newBidder,amount);
    }

    function setFinished() OnlyBlockTime public {
        
    }
}
