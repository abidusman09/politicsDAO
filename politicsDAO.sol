// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PoliticsDAO {
    
    address public owner;
    uint public quorum = 5000; // 50% + 1 of total voters
    uint public totalVoters = 10000; // Total number of voters
    
    struct Voter {
        bool voted;
        bool supportsModi;
    }
    
    mapping(address => Voter) public voters;
    uint public yesVotes;
    uint public noVotes;
    bool public electionEnded = false;
    
    event VoteCast(address voter, bool supportsModi);
    event ElectionEnded(bool modiWins);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    function castVote(bool supportsModi) public {
        require(!voters[msg.sender].voted, "You have already voted");
        require(!electionEnded, "Election has ended");
        voters[msg.sender].voted = true;
        voters[msg.sender].supportsModi = supportsModi;
        if (supportsModi) {
            yesVotes++;
        } else {
            noVotes++;
        }
        emit VoteCast(msg.sender, supportsModi);
    }
    
    function endElection() public onlyOwner {
        require(!electionEnded, "Election has already ended");
        require(yesVotes + noVotes >= quorum, "Quorum not reached");
        if (yesVotes > noVotes) {
            emit ElectionEnded(true);
        } else {
            emit ElectionEnded(false);
        }
        electionEnded = true;
    }
    
}
