pragma solidity ^0.4.18;

contract Optimist {

    uint256 public stake;

    struct Data {
        bytes input;
        address sender;
    }

    constructor(uint _stake, bytes4 _proofFunction, bytes4 _submissionFunction) {
        stake = _stake;
    }

    function commit(bytes input) external payable {
        require(msg.value == stake, "incorrect stake amount sent.");
    }

    function challenge() external {

    }

}
