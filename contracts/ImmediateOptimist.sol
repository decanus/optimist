pragma solidity ^0.5.0;

import "./Optimist.sol";
import "./DataStorageWithRemoval.sol";

contract ImmediateOptimist is Optimist {

    struct Commitment {
        bytes input;
        uint256 key;
    }

    DataStorageWithRemoval public dataStorage;

    uint256 public stake;

    Commitment[] public commitments;

    event Committed(address indexed committer, uint256 index);

    /// @param _stake The required stake amount in wei.
    /// @param _cooldown The cooldown time in seconds.
    /// @param _storage The storage contract.
    constructor(uint256 _stake, uint256 _cooldown, DataStorageWithRemoval _storage) public {
        stake = _stake;
        cooldown = _cooldown;
        dataStorage = _storage;
    }

    /// @dev This function submits data.
    /// @param input The input data to submit.
    function submit(bytes calldata input) external payable {
        require(msg.value == stake);

        uint256 key = dataStorage.submit(input);

        commitments.push(
            Commitment({
                input: input,
                key: key
            })
        );

        emit Submitted(msg.sender, (commitments.length - 1), input);
    }

    /// @dev This function challenges a submission by calling the validation function.
    /// @param id The id of the submission to challenge.
    function challenge(uint256 id) external {
        Commitment storage commitment = commitments[id];

        require(commitment.submitted != 0);

        require(!dataStorage.isValid(commitment.input));

        uint256 key = commitment.key;
        delete commitments[id];

        dataStorage.remove(key);

        msg.sender.transfer(stake);

        emit Challenged(msg.sender, id);
    }
}
