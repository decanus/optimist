pragma solidity ^0.4.18;

contract Optimist {

    uint256 public stake;

    bytes4 public proofFunction;
    bytes4 public submissionFunction;

    struct Data {
        bytes input;
        address sender;
    }

    Data[] public commitments;

    event DataCommitted(address indexed sender, uint256 index, bytes input);
    event DataChallenged(address indexed challenger, uint256 index);

    constructor(uint _stake, bytes4 _proofFunction, bytes4 _submissionFunction) public {
        stake = _stake;
        proofFunction = _proofFunction;
        submissionFunction = _submissionFunction;
    }

    function commit(bytes input) external payable {
        require(msg.value == stake, "incorrect stake amount sent.");

        Data data = Data({
            input: input,
            sender: msg.sender
        });

        commitments.push(data);

        // @todo call submission function

        emit DataCommitted(msg.sender, commitments.length - 1, input);
    }

    function challenge(uint256 id) external {
        require(commitments[id].sender != 0x0, "commitment for id does not exist");
        /// @todo call verifier function

        delete commitments[id];

        msg.sender.transfer(stake);
        emit DataChallenged(msg.sender, id);
    }

}
