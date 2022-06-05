pragma solidity >=0.7.0 <0.9.0;

contract Coin {

    address public minter;
    //hold the associations
    mapping (address => uint) public balances;
    //log
    event Sent(address from, address to, uint amount);

    modifier onlyMinter {
        require(msg.sender == minter, "only minter can do this");
        _;
    }

    modifier amontGreaterThan(uint amount){
        require(amount < 1e60);
        _;
    }

    modifier balanceGreaterThanAmount(uint amount){
        require(amount <= balances[msg.sender], "insuffienct balance");
        _;
    }

    constructor() {
        minter  = msg.sender;
        //returns the adress the wallet 
    }

    function mint(address receiver, uint amount) public {
       balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {

        require(amount >= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);

    }

}