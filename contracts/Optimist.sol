pragma solidity ^0.4.18;

contract Optimist {

    uint256 public stake;

    bytes4 public proofFunction;
    bytes4 public submissionFunction;

    struct Data {
        bytes input;
        address sender;
    }

    constructor(uint _stake, bytes4 _proofFunction, bytes4 _submissionFunction) public {
        stake = _stake;
        proofFunction = _proofFunction;
        submissionFunction = _submissionFunction;
    }

    function commit(bytes input) external payable {
        require(msg.value == stake, "incorrect stake amount sent.");

        // @todo put data into mapping of contract
    }

    function challenge() external {
        /// @todo call verifier function

        msg.sender.transfer(stake);
    }

}
