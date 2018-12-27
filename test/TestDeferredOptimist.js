const Optimist = artifacts.require('./DeferredOptimist.sol');
const DataStorage = artifacts.require('./mocks/DataStorageMock.sol');

const utils = require('./helpers/Utils.js');
const BigNumber = require('bignumber.js');

contract('DeferredOptimist', function(accounts) {

    let stake, cooldown;

    let optimist, storage;

    beforeEach(async function() {
        storage = await DataStorage.new();

        stake = new BigNumber('1e18');
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
            
            assert.fail('did not fail');
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
            
            assert.fail('did not fail');
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
            assert.isNull(commitment[0], 'commitment should be empty (deleted)');

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
            assert.isNull(commitment[0]);

            try {
                await optimist.commit(0);
            } catch (error) {
                return utils.ensureException(error);
            }
            
            assert.fail('did not fail');
        });

        it('should allow commit if submission was not challenged', async () => {
            let data = '0x01';
            await optimist.submit(data, {
                value: stake,
                from: accounts[0]
            });

            let commitment = await optimist.commitments.call(0);
            assert.equal(commitment[0], data);
            assert.equal(commitment[2], accounts[0]);

            await utils.increaseTime(cooldown + 10);

            await optimist.commit(0);
        });
    });

});
