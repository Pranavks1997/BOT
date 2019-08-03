pragma solidity ^0.5.10;

contract Election {

    struct Ticket {
        uint gid;
        uint objid;
        string publicKey;
    }

    struct Data {
        string userData;
    }

    mapping(uint => Ticket) public tickets;

    string public candidate;
    constructor () public {
    }
}
