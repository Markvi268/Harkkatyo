// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
//import "./auction.sol";
import "hardhat/console.sol";

contract SalesAnnouncement {
  //  mapping(uint256 => Auction) private announcements; // ilmoituksien osoite
    address payable private owner; // ilmoituksen omistaja
    address payable private addr; // huutokaupan osoite
    address payable[] private previousBidders; // aikaisemmat tarjoajat
    string  private title; // kohteen otsikko
    string  private description; // kohteen kuvaus
    uint256 private endtime; // päättymisaika
    uint256 private deposit; // pantti
    uint256 private price; // pohjahinta/uusihinta
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
        //Yell(msg.sender,msg.value);
    }

    modifier Onlyowner() {
        require(msg.sender == owner,"You are not the submitter of the sale notice");
        _;
    }

    modifier OnlyBlockTime(){
        require(block.number <= endtime,"Auction closed");
        _;
    }

   // huudetaan tuotetta ja palauteutetaan rahat edelliselle omistajalle
    function Yell(address payable _newBidder,uint256 amount) OnlyBlockTime payable public {
        require(amount > price,"Your offer is too low");

        setpreviousBidders(_newBidder);
        setNewPrice(amount);
        if(index > 0){
            address payable bidder = getpreviousBidders();
            bidder.transfer(getBalance());
        }

        emit newYell(_newBidder,amount);

    }

    // funktio kaupan sinetöimiseksi
    function setFinished() OnlyBlockTime public {
        
    }

    // haetaan edellinen huutaja
    function getpreviousBidders() private view returns(address payable){
        uint _index = index - 1;
        return previousBidders[_index];
       
    }

    // asetetaan edellinen huutaja
    function setpreviousBidders(address payable _bidder) private{
        previousBidders.push(_bidder);
         index++;
    }

    function getBalance()public view returns(uint){
        return address(this).balance;
    }

    function setNewPrice(uint _newPrice)private{
        price = _newPrice;
    }

    function getNewPrice()private view returns(uint){
        return price;
    }
}
