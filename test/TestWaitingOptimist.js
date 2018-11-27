const Optimist = artifacts.require('./WaitingOptimist.sol');
const DataStorage = artifacts.require('./mocks/DataStorageMock.sol');

const utils = require('./helpers/Utils.js');

contract('WaitingOptimist', function(accounts) {

    let stake, cooldown;

    let optimist, storage;

    beforeEach(async function() {
        storage = await DataStorage.new();

        stake = 10**18;
        cooldown = 50000;

        optimist = await Optimist.new(stake, cooldown, storage.address);
    });

    describe('submit', async () => {

        it('should accept submission with correct stake', async () => {
            const data = '0x01';

            await optimist.submit(data, {
                value: stake,
                from: accounts[0]
            });

            let commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], data);
            assert.equal(commitment[2], accounts[0]);
        });

        it('should fail when submitting with incorrect stake', async () => {
            try {
                await optimist.submit('0x0', {
                    value: 0,
                    from: accounts[0]
                });
            } catch (error) {
                return utils.ensureException(error);
            }
        });
    });

    describe('challenge', async () => {

        it('should fail to challenge when submission is valid', async () => {
            await optimist.submit('0x01', {
                value: stake,
                from: accounts[0]
            });

            try {
                await optimist.challenge(0, {
                    from: accounts[1]
                });
            } catch (error) {
                return utils.ensureException(error);
            }
        });

        it('should slash when invalid submission is challenged', async () => {
            let data = '0x00';
            await optimist.submit(data, {
                value: stake,
                from: accounts[0]
            });

            let commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], data);
            assert.equal(commitment[2], accounts[0]);

            await optimist.challenge(0, {
                from: accounts[1]
            });

            commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], '0x');

            // @todo validate user got stake
        });
    });

    describe('commit', async () => {

        it('should fail to commit if submission was successfully challenged', async () => {
            let data = '0x00';
            await optimist.submit(data, {
                value: stake,
                from: accounts[0]
            });

            let commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], data);
            assert.equal(commitment[2], accounts[0]);

            await optimist.challenge(0, {
                from: accounts[1]
            });

            commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], '0x');

            try {
                await optimist.commit(0);
            } catch (error) {
                return utils.ensureException(error);
            }
        });
    });

});