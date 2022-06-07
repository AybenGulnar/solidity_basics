// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract  myGame{
    uint public playerCount = 0;
    mapping (address => Player) public players;
    enum Level {Novice, Interemediate, Advanced}

struct  Player {
    address playerAdress;
    Level playerLevel;
    string firstName;
    string lastName;
    uint createdTime;

}

function addPlayer(string memory firstName, string memory lastName) public {
    players[msg.sender] = Player(msg.sender, Level.Novice, firstName, lastName,block.timestamp);
    playerCount +=1;
}
function getPlayerLevel(address playerAdress) public view returns(Level) {
    Player storage player = players[playerAdress];
    return player.playerLevel;
}

function changePlayerLevel(address playerAddress) public {
    Player storage player = players[playerAddress];
    if (block.timestamp >= player.createdTime + 20) {
        player.playerLevel = Level.Interemediate;
    }

}

}
    


