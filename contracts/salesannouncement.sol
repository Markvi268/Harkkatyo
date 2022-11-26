// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;
/* IMPORTS! */
import "hardhat/console.sol";

contract SalesAnnouncement {
    address payable private owner; // ilmoituksen omistaja
    address payable private addr; // huutokaupan osoite
    address payable private previousBidder; // aikaisempi tarjoaja
    address private caller; // apu funktion käytössä oleva, jolla saadaan tietää omistaja tai korkein huutaja
    string  private title; // kohteen otsikko
    string  private description; // kohteen kuvaus
    uint256 private endtime; // päättymisaika
    uint256 private deposit; // pantti
    uint256 private price; // pohjahinta/uusihinta
    uint256 private reward; //huutokaupan palkkio

    // eventit
    event newYell(address who, uint256 howMuch);
    event sold(address newowner, uint256 newPrice);
    event receivePayales(address PayToReceive,uint offering);


    constructor(address payable _addr,address payable _owner,string memory _title,string memory _description,uint256 _startprice,uint256 _endtime, uint _reward) {
        owner = _owner;
        addr = _addr;
        title = _title;
        description = _description;
        price = _startprice;
        endtime = block.number + _endtime;
        reward = _reward;

    }

    // sopimukselle rahan siirto luokitellaan huudoksi
    receive() external payable {
      Yell(payable(msg.sender));
      emit receivePayales(msg.sender,msg.value);
    }

    modifier Onlyowner() {
        require(caller == owner || caller == previousBidder,"You are not the sender of the sale notice or the highest bidder");
        _;
    }

    modifier OnlyBlockTime(){
        require(block.number <= endtime,"Auction closed");
        _;
    }

    modifier OnlyBlockTimeIsDone(){
        require(block.number >= endtime,"The auction is still running");
        _;
    }

   // huudetaan tuotetta ja palauteutetaan rahat edelliselle omistajalle
    function Yell(address payable _newBidder) OnlyBlockTime  payable public returns (bool) {
        require(msg.value > price,"Your offer is too low");
        if(previousBidder != address(0)){
            previousBidder.transfer(deposit);
            previousBidder = _newBidder;
            deposit = msg.value;
            price = deposit;
        }
        else{
            previousBidder = _newBidder;
            deposit = msg.value;
            price = deposit;
        }

        emit newYell(_newBidder,msg.value);
        return true;
    }

    // apu funktio kaupan sinetöimiseksi. en osannut kutsua suoraan niin tein tämmösen. toimii aikaliki samallalailla
    function checkOwner(address checkAddress) public returns(bool){
        caller = checkAddress;
        setFinished();
        return true;

    }

    // funktio kaupan sinetöimiseksi
    function setFinished() Onlyowner OnlyBlockTimeIsDone private returns(bool) {
        require(previousBidder != address(0x0), "No one shouted the product");
        uint balance = getBalance();
        uint comission = balance * reward / 100;
        uint ownerpart = balance - comission;
        console.log(comission);
        owner.transfer(ownerpart);
        payable(addr).transfer(comission);
        owner = previousBidder;
        emit sold(previousBidder, deposit);
        return true;

    }

    // haetaan sopimuksen varallisuus
    function getBalance()public view returns(uint){
        return address(this).balance;
    }

}
