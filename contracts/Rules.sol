pragma solidity ^0.5.8;

contract Election {

    uint gId;
    uint objId;

    struct Ticket {
        uint gId;
        uint objId;
        string publicKey;
    }

    struct Transaction {
        string obj;
        string sender;
        string reciever;
        string failed;
        int masterFlag;
        int followerFlag;
    }
    mapping(uint => Transaction) public transatctions;

    mapping(address => Ticket) public tickets;

    // //Function to check if objectIdExists.
    //algo 1
    //  function objIdExists(uint _objId) public returns(bool)   {
    //      return require(_objId, false);
    //  }

    //  function grpIdExists(string memory _gId) public returns (bool) {
    //      return require(_gId, false);
    //  }




    //algo2


    //algo3
}
