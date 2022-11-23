// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "hardhat/console.sol";


contract SalesAnnouncement{

    mapping(address => uint) public huutajat;
    address payable public dealer; // huutokaupan omistaja
    address payable public person; // ilmoituksen jättäjä/omistaja
    address payable highestYell;
    address payable[] public previousBidder; // aikaisemmat tarjoajat
    string public title; // kohteen otsikko
    string public description; // kohteen kuvaus
    uint public endtime; // päättymisaika
    uint public highestPrice; // uusihinta/pohjahinta
    uint public reward; //huutokaupan palkkio
    uint index = 0;

    constructor(address payable _dealer,address payable _person, string memory _title, string memory _description, uint _price, uint _endtime,uint _reward){

        dealer = _dealer;
        person = _person;
        title = _title;
        description = _description;
        highestPrice = _price;
        endtime = block.number + _endtime;
        reward = _reward;
        console.log(endtime);

    }


    receive() external payable{
        require(msg.value > highestPrice,"Price is higher than you offers");
        highestPrice = msg.value;
    }

    event newYell(address who,uint howMuch);

    modifier OnlyPerson(){
        console.log(msg.sender);
        require(msg.sender == person,"You are not the submitter of the sale notice");
        _;
    }

    modifier OnlyHigherShoulter(){
        require(msg.sender == highestYell, "You are not the higher yell");
        _;
    }

    function setYell(address payable _newoffer,uint offer)external payable{
        previousBidder.push(payable(_newoffer));
           
        highestPrice = offer;

        index++;
        emit newYell(_newoffer,offer);
        
    }

    function setFinished()OnlyPerson public{
        require(endtime == block.number,"Not yet avaibled");
        highestYell = previousBidder[index];
        highestYell = person;

    }




}