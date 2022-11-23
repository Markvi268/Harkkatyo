// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "hardhat/console.sol";

contract SalesAnnouncement {
    address payable public dealer; // huutokaupan omistaja
    address payable public person; // ilmoituksen jättäjä/omistaja
    address public previousBidder; // aikaisemmat tarjoajat
    address public bidder;
    string  public title; // kohteen otsikko
    string  public description; // kohteen kuvaus
    uint256 public endtime; // päättymisaika
    uint256 public deposit; // pantti
    uint256 public price; // pohjahinta
    uint256 public newPrice; // uusihinta
    uint256 public reward; //huutokaupan palkkio
    uint256 public ownerpart; // omistajan osuus
    uint256 index = 0;

    constructor(
        address payable _dealer,
        address payable _person,
        string memory _title,
        string memory _description,
        uint256 _price,
        uint256 _endtime,
        uint256 _reward
    ) {
        dealer = _dealer;
        person = _person;
        title = _title;
        description = _description;
        price = _price;
        endtime = block.number + _endtime;
        reward = _reward;
        console.log(person);
    }

    receive() external payable {
        setYell(msg.sender, msg.value);
    }

    event newYell(address who, uint256 howMuch);

    modifier OnlyPerson() {
        require(
            msg.sender == person,
            "You are not the submitter of the sale notice"
        );
        _;
    }

    function setYell(address _newBidder, uint256 amount) public payable {
        require(amount >= price, "You offer is too low");

        uint256 comission = amount / reward;
        ownerpart = amount - comission;
        bidder = previousBidder;
        previousBidder = _newBidder;

        newPrice = deposit;
        deposit = amount;

        console.log(newPrice);

        emit newYell(_newBidder, amount);
    }
}
