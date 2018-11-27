pragma solidity ^0.4.24;

import "./Optimist.sol";
import "./DataStorage.sol";

contract WaitingOptimist is Optimist {

    struct Commitment {
        bytes input;
        uint256 submitted;
        address submitter;
    }

    DataStorage public dataStorage;

    uint256 public stake;
    uint256 public cooldown;

    Commitment[] public commitments;

    event Committed(address indexed committer, uint256 index);

    /// @param _stake The required stake amount in wei.
    /// @param _cooldown The cooldown time in seconds.
    /// @param _storage The storage contract.
    constructor(uint256 _stake, uint256 _cooldown, DataStorage _storage) public {
        stake = _stake;
        cooldown = _cooldown;
        dataStorage = _storage;
    }

    /// @dev This function submits data, starting the challenge period.
    /// @param input The input data to submit.
    function submit(bytes input) external payable {
        require(msg.value == stake);

        commitments.push(
            Commitment({
                input: input,
                submitted: now,
                submitter: msg.sender
            })
        );

        emit Submitted(msg.sender, (commitments.length - 1), input);
    }

    /// @dev This function challenges a submission by calling the validation function.
    /// @param id The id of the submission to challenge.
    function challenge(uint256 id) external {
        Commitment storage commitment = commitments[id];

        require(commitment.submitted + cooldown >= now);

        require(!dataStorage.isValid(commitment.input));

        delete commitments[id];
        msg.sender.transfer(stake);

        emit Challenged(msg.sender, id);
    }

    /// @dev This function finalizes a submission by adding it to the storage.
    /// @param id The id of the submission to finalize.
    function commit(uint256 id) external {
        Commitment storage commitment = commitments[id];

        require(commitment.submitter != address(0x0));
        require(commitment.submitted + cooldown < now);

        dataStorage.submit(commitment.input);

        address submitter = commitment.submitter;
        delete commitments[id];
        submitter.transfer(stake);

        emit Committed(msg.sender, id);
    }
}
