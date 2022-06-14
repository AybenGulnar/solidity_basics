pragma solidity >=0.7.0 <0.9.0;

contract SimpleAuction {

    //parameteres of the simpleauction
    address payable public beneficiary;
    uint public auctionEndTime;

    //currentstate of the auctionendtime
    address public highestBidder;
    uint public  highestBid;

    mapping(address => uint) public pendingReturns; 

    bool ended  = false;

    event HighestBidIncrease(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _biddingTime, address payable _beneficiary) {
        beneficiary =_beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;

    }

    function bid() public payable {
        if(block.timestamp > auctionEndTime){
            revert("THE AUCTION HAS ALREADY ENDED");
        }

        if(msg.value <= highestBid){
            revert("THERE IS ALREADY A HIGHER OR EQUAL BID");

        }

        if(highestBid != 0){
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncrease(msg.sender, msg.value);

    }

    function withdraw() public returns(bool){
        uint amount = pendingReturns[msg.sender];
        if(amount > 0){
            pendingReturns[msg.sender] = 0;

            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }

        return true;

    }

    function auctionEnd() public {
        if(block.timestamp < auctionEndTime) {
            revert("AUCTION HAS NOT ENDED");

        }

        if(ended ){
            revert("THE FUNCTION HAS ALREADY CALLED");
        }

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }

}