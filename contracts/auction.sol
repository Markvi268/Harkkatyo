// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */
import "./salesannouncement.sol";
import "hardhat/console.sol";

contract Auction {
    uint256 private reward; // palkkio %
    mapping(uint256 => SalesAnnouncement) private announcements; // ilmoituksien osoite
    address payable public owner; // huutokaupan omistaja
    uint256 index = 0;

    constructor() {
        reward = 5; // alustetaan välityspalkkio 5%:iin
        owner = payable(msg.sender);
    }

    event newSalesAd(address who, address addr);
    event rewardChange(uint256 reward);

    modifier OnlyOwner() {
        require(msg.sender == owner, "Decline, you are not the owner");
        _;
    }

    function exchangeCommission(uint256 _reward) public OnlyOwner {
        // vaihdetaan välityspalkkio
        reward = _reward;
        emit rewardChange(_reward);
    }

    function getBalance() public view OnlyOwner returns (uint256) {
        return address(this).balance;
    }

    function createAnotice(
        string memory _title,
        string memory _description,
        uint256 _startprice,
        uint256 _endtime
    ) public {
        SalesAnnouncement sales = new SalesAnnouncement(
            owner,
            payable(msg.sender),
            _title,
            _description,
            _startprice,
            _endtime,
            reward
        );
        announcements[index] = sales;
        emit newSalesAd(msg.sender, address(sales));
        index++;
    }

    function makeAshout(uint256 _index) public payable {
        SalesAnnouncement sales = announcements[_index]; // valitaan ilmoitus mitä huudetaan
        sales.setYell(msg.sender, msg.value);
    }

    function getAnnouncements(uint256 _index) public view returns (address) {
        SalesAnnouncement sales = announcements[_index];
        return address(sales);
    }
}
