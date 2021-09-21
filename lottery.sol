// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    address public manager;
    address payable[] public participants;
    //payable is used cause we gonna payback tghe amount to winner of lottery
    
    constructor() 
    //constructor is a function that gets executed once only
    {
        manager=msg.sender;
        // msg.sender is global variable
    }
    receive() external payable 
    // you can use receive func once only , must be external and always payable
    { require(msg.value==1 ether) ;
    //participants are allowed only  when they give more than one ether
        participants.push(payable(msg.sender));
        //to register the addresses of paricipants and this is  to pay them after one wins
    }
    function getBalance() public view returns(uint)
    { require(msg.sender== manager); //only manager can see all fund collected in the lottery
        return address(this).balance;
    }
    function random() public view returns(uint) // to pick a random number(random generation)
    {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
        //keccak256 computes the Keccak-256 hash of the input (this is for random value generation)
    //(do not use them into real deployment)
        //\abi. encodePacked("AAAA"); Simply produces 0x41414141
    }
    //above function creates random number such as 
//uint256: 80000304257973493853657784246583179832243394636934821072922171631670034647541
//but we need winner from our participants so we need index of the participants
function selectWinner() public 
{
    require(msg.sender==manager);           // to activate event
    require(participants.length>=3);        // 
    uint r=random();                        // created random number got stored in the r
    address payable winner;
    uint index= r % participants.length;    // index number is calculated from this function 
    //why % is used ? cause it will give index number smaller than the participants length 
    // one more there are 0-7 indices and lenght is 8
    winner = participants[index];
   winner.transfer(getBalance());   //to transfer to winner ccount
   participants=new address payable[](0); //resetting 
   
}
}
