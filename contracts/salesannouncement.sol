// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SalesAnnouncement{

    mapping(address => uint) public huutajat;
    address payable public dealer; // huutokaupan omistaja
    address payable public person; // ilmoituksen jättäjä
    address payable public higherYell;
    address payable[] public previousOffers;
    string public title; // kohteen otsikko
    string public description; // kohteen kuvaus
    uint public floorprice; // pohjahinta
    uint public endtime; // päättymisaika
    uint public newPrice; // uusihinta
    uint public reward;
    uint index = 0;

    function newNotification(address payable _dealer,address payable _person, string memory _title, string memory _description, uint _price, uint _endtime,uint _reward) external payable{

        dealer = _dealer;
        person = _person;
        title = _title;
        description = _description;
        floorprice = _price;
        endtime = block.number + _endtime;
        reward = _reward;
    }

    receive() external payable{
        require(msg.value < floorprice,"Floorprice is higher");
        newPrice = msg.value;
    }

    event newYell(address who,uint howMuch);

    modifier OnlyPerson(){
        require(msg.sender == person,"You are not the submitter of the sale notice");
        _;
    }

    modifier OnlyHigherShoulter(){
        require(msg.sender == higherYell, "You are not the higher yell");
        _;
    }

    function setYell(address _newoffer,uint offer)external payable returns(bool){
        require(offer < floorprice,"You offer is lower than floorprice");
        require(newPrice > offer,"You offer is too low");
        
        newPrice = offer;
        emit newYell(_newoffer,offer);
        return true;
    }

    function finished()OnlyPerson OnlyHigherShoulter public{

    }




}