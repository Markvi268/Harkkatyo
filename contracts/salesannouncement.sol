// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/* IMPORTS! */

contract SalesAnnouncement{
    mapping(address => uint) public huutajat;
    string public otsikko;
    string public kuvaus;
    uint public pohjahinta;
    uint public paattymisaika;


    constructor(){

    }

    function huuda () public payable {

    }

    function luoMyyntiIlmoitus(string memory _otsikko, string memory _kuvaus) public{
        otsikko = _otsikko;
        kuvaus = _kuvaus;
    }

}