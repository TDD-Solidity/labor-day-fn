import { expect } from "chai";
import { ethers } from "hardhat";

describe("ItWithinLoop", function () {

    let itWithinLoop: any;
    let ItWithinLoop: any;

    before(async () => {

        ItWithinLoop = await ethers.getContractFactory("ItWithinLoop");

    })

    beforeEach(async () => {

        itWithinLoop = await ItWithinLoop.deploy();

    })

    describe('greet function', () => {

        const testCases = [

            [0, 1, '9.99', '10.1'],
            [1, 1, '10', '10.25'],
            [2, 2, '10.03', '10.1'],
            [5, 5, '10.199', '10.3'],
            [10, 10, '10.4', '10.5'],
            [100, 100, '14', '16'],
            [1000, 1000, '58', '59'],
            [1000000, 1000000, '50000', '50011'],
            [10000000, 10000000, '490000', '501000'],
            [100000000, 100000000, '5000000', '5001100'],
            [1000000000, 1000000000, '49000000', '50011000'],
      
            // high apple supply, low trees supply
            
            [1000000000, 5,  '3000', '3200'],
            [1000000000, 100,  '15000', '16000'],
            [1000000000, 5000,  '110000', '120000'],
            [1000000000, 50000,  '350000', '360000'],
            [1000000000, 1000000,  '1500000', '2000000'],
            
            // low apple supply, high trees supply
            
            [5, 1000000000, '3000', '3200'],
            [100, 1000000000, '15000', '16000'],
            [5000, 1000000000, '110000', '120000'],
            [50000, 1000000000, '350000', '360000'],
            [1000000, 1000000000, '1500000', '2000000'],
          ]
      
          testCases.forEach(testCase => {

              it('says hello', async () => {
      
                  expect(await itWithinLoop.greet()).to.equal('Hello')
      
              })

          })

    })

    describe('get_num function', () => {

        it('returns 5', async () => {

            expect(await itWithinLoop.get_num()).to.equal(5)

        })

    })

})