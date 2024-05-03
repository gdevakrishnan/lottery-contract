// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract Lottery {
    address payable[] private Players;
    address payable private Manager;
    address payable private Winner;

    constructor () {
        Manager = payable(msg.sender);
    }

    function participate() payable public {
        require(msg.sender != Manager, "You are the manager");
        require(msg.value >= 1 ether, "You needs to pay minimum 1 ether");
        Players.push(payable(msg.sender));
    }

    function getBalance() private returns (uint) {
        require(msg.sender == Manager, "You are not the manager");
        return address(this).balance;
    }

    function random() private returns (uint){
        return 
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        Players.length
                    )
                )
            );
    }

    function GetWinner() payable public {
        require(msg.sender == Manager, "You are not the manager");
        require(Players.length >= 3, "Required minimum 3 players");
        uint256 r = random();
        uint256 Index = r % Players.length;
        Winner = Players[Index];
        Winner.transfer(getBalance());
        Players = new address payable[](0);
    }
}

// 0xDD6133A4bdD7271864201dfC179c05DD1E002EB8