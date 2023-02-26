//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery{
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping(uint=>address payable) public lotterHistory;

    constructor(){
        owner = msg.sender;
        lotteryId=1;
    }

    function getWinnerByLottery(uint a) public view returns(address payable){
        return lotterHistory[a];
    }

// get the current balance of the smart contract
    function getBalance() public view returns (uint){
        // address.this is accessing the smart contract
        return address(this).balance;
    }

    // get all the players those who have registered for the lottery
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }


    // mak ethe payment and enter the lottery
    function enter() public payable {

        require(msg.value>0.01 ether);
        // address of player entering the lottery
        players.push(payable(msg.sender));
    }

    // generate the number 
    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }


    // pick the winner and transfer the funds to that guys account
    function pickWinner() public onlyOwner{
        // require(msg.sender==owner);
        uint index = getRandomNumber()%players.length;
        players[index].transfer(address(this).balance);
        lotterHistory[lotteryId] = players[index];
        lotteryId++;
        

        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

}
